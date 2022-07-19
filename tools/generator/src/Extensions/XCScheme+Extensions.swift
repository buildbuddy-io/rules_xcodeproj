import XcodeProj

enum XCSchemeConstants {
    // GH399: Derive the defaultLastUpgradeVersion
    static let defaultLastUpgradeVersion = "1320"
    static let lldbInitVersion = "1.7"
    static let defaultBuildConfigurationName = "Debug"
}

// MARK: XCScheme.BuildableReference

extension XCScheme.BuildableReference {
    convenience init(pbxTarget: PBXTarget, referencedContainer: String) {
        self.init(
            referencedContainer: referencedContainer,
            blueprint: pbxTarget,
            buildableName: pbxTarget.buildableName,
            blueprintName: pbxTarget.name
        )
    }
}

// MARK: XCScheme.Scheme

extension XCScheme {
    convenience init(
        buildMode: BuildMode,
        schemeInfo: XCSchemeInfo
    ) {
        let buildAction: XCScheme.BuildAction?
        if let buildActionInfo = schemeInfo.buildActionInfo {
            buildAction = .init(buildMode: buildMode, buildActionInfo: buildActionInfo)
        } else {
            buildAction = nil
        }

        let testAction: XCScheme.TestAction?
        if let testActionInfo = schemeInfo.testActionInfo {
            testAction = .init(testActionInfo: testActionInfo)
        } else {
            testAction = nil
        }

        let launchAction: XCScheme.LaunchAction?
        if let launchActionInfo = schemeInfo.launchActionInfo {
            launchAction = .init(buildMode: buildMode, launchActionInfo: launchActionInfo)
        } else {
            launchAction = nil
        }

        let profileAction: XCScheme.ProfileAction?
        if let profileActionInfo = schemeInfo.profileActionInfo {
            profileAction = .init(profileActionInfo: profileActionInfo)
        } else {
            profileAction = nil
        }

        self.init(
            name: schemeInfo.name,
            lastUpgradeVersion: XCSchemeConstants.defaultLastUpgradeVersion,
            version: XCSchemeConstants.lldbInitVersion,
            buildAction: buildAction,
            testAction: testAction,
            launchAction: launchAction,
            profileAction: profileAction,
            analyzeAction: .init(analyzeActionInfo: schemeInfo.analyzeActionInfo),
            archiveAction: .init(archiveActionInfo: schemeInfo.archiveActionInfo),
            wasCreatedForAppExtension: schemeInfo.wasCreatedForAppExtension ? true : nil
        )
    }
}

// MARK: XCScheme.BuildAction

extension XCScheme.BuildAction {
    convenience init(
        buildMode: BuildMode,
        buildActionInfo: XCSchemeInfo.BuildActionInfo
    ) {
        self.init(
            buildActionEntries: buildActionInfo.targetInfos.buildActionEntries,
            preActions: buildMode.usesBazelModeBuildScripts ?
                buildActionInfo.targetInfos.bazelBuildPreActions : [],
            parallelizeBuild: true,
            buildImplicitDependencies: true
        )
    }
}

// MARK: XCScheme.BuildAction.Entry

extension XCScheme.BuildAction.Entry {
    convenience init(withDefaults buildableReference: XCScheme.BuildableReference) {
        self.init(
            buildableReference: buildableReference,
            buildFor: [
                .running,
                .testing,
                .profiling,
                .archiving,
                .analyzing,
            ]
        )
    }
}

// MARK: XCScheme.ExecutionAction

extension XCScheme.ExecutionAction {
    /// Initialize the output file for build with Bazel
    static let initBazelBuildOutputGroupsFile = XCScheme.ExecutionAction(
        scriptText: #"""
mkdir -p "${BAZEL_BUILD_OUTPUT_GROUPS_FILE%/*}"
if [[ -s "$BAZEL_BUILD_OUTPUT_GROUPS_FILE" ]]; then
    rm "$BAZEL_BUILD_OUTPUT_GROUPS_FILE"
fi
"""#,
        title: "Initialize Bazel Build Output Groups File"
    )

    /// Create an ExecutionAction that builds with Bazel
    convenience init(
        bazelBuildFor buildableReference: XCScheme.BuildableReference,
        name: String,
        hostIndex: Int?
    ) {
        let hostTargetOutputGroup: String
        if let hostIndex = hostIndex {
            hostTargetOutputGroup = #"""
echo "b $BAZEL_HOST_TARGET_ID_\#(hostIndex)" >> "$BAZEL_BUILD_OUTPUT_GROUPS_FILE"
"""#
        } else {
            hostTargetOutputGroup = ""
        }

        let scriptText = #"""
echo "b $BAZEL_TARGET_ID" >> "$BAZEL_BUILD_OUTPUT_GROUPS_FILE"
\#(hostTargetOutputGroup)
"""#
        self.init(
            scriptText: scriptText,
            title: "Set Bazel Build Output Groups for \(name)",
            environmentBuildable: buildableReference
        )
    }
}

// MARK: XCScheme.TestAction

extension XCScheme.TestAction {
    convenience init(testActionInfo: XCSchemeInfo.TestActionInfo) {
        self.init(
            buildConfiguration: testActionInfo.buildConfigurationName,
            macroExpansion: nil,
            testables: testActionInfo.targetInfos
                .filter(\.pbxTarget.isTestable)
                .map { .init(skipped: false, buildableReference: $0.buildableReference) },
            customLLDBInitFile: "$(BAZEL_LLDB_INIT)"
        )
    }
}

// MARK: XCScheme.LaunchAction

extension XCScheme.LaunchAction {
    convenience init(buildMode: BuildMode, launchActionInfo: XCSchemeInfo.LaunchActionInfo) {
        let productType = launchActionInfo.targetInfo.productType
        self.init(
            runnable: launchActionInfo.runnable,
            buildConfiguration: launchActionInfo.buildConfigurationName,
            macroExpansion: launchActionInfo.macroExpansion,
            selectedDebuggerIdentifier: launchActionInfo.debugger,
            selectedLauncherIdentifier: launchActionInfo.launcher,
            askForAppToLaunch: launchActionInfo.askForAppToLaunch ? true : nil,
            environmentVariables: buildMode.usesBazelEnvironmentVariables ?
                productType.bazelLaunchEnvironmentVariables : nil,
            launchAutomaticallySubstyle: productType.launchAutomaticallySubstyle,
            customLLDBInitFile: "$(BAZEL_LLDB_INIT)"
        )
    }
}

// MARK: XCScheme.ProfileAction

extension XCScheme.ProfileAction {
    convenience init(profileActionInfo: XCSchemeInfo.ProfileActionInfo) {
        self.init(
            buildableProductRunnable: profileActionInfo.runnable,
            buildConfiguration: profileActionInfo.buildConfigurationName
        )
    }
}

// MARK: XCScheme.AnalyzeAction

extension XCScheme.AnalyzeAction {
    convenience init(analyzeActionInfo: XCSchemeInfo.AnalyzeActionInfo) {
        self.init(buildConfiguration: analyzeActionInfo.buildConfigurationName)
    }
}

// MARK: XCScheme.ArchiveAction

extension XCScheme.ArchiveAction {
    convenience init(archiveActionInfo: XCSchemeInfo.ArchiveActionInfo) {
        self.init(
            buildConfiguration: archiveActionInfo.buildConfigurationName,
            revealArchiveInOrganizer: true
        )
    }
}