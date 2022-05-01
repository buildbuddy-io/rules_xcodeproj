import PathKit
import XcodeProj

// DEBUG BEGIN
import Darwin
// DEBUG END

extension Generator {
    /// Creates an array of `XCScheme` entries for the specified targets.
    static func createXCSchemes(
        workspaceOutputPath: Path,
        pbxTargets: [TargetID: PBXNativeTarget]
    ) throws -> [XCScheme] {
        return try createXCSchemes(
            referencedContainer: .init(xcodeprojPath: workspaceOutputPath),
            pbxTargets: pbxTargets
        )
    }

    static func createXCSchemes(
        referencedContainer: XcodeProjContainerReference,
        pbxTargets: [TargetID: PBXNativeTarget]
    ) throws -> [XCScheme] {
        return try pbxTargets.map { $0.1 }.map { pbxTarget in
            try createXCScheme(
                referencedContainer: referencedContainer,
                pbxTarget: pbxTarget
            )
        }
    }

    static func createXCScheme(
        referencedContainer: XcodeProjContainerReference,
        pbxTarget: PBXNativeTarget
    ) throws -> XCScheme {
        let buildableReference = pbxTarget.createBuildableReference(
            referencedContainer: referencedContainer
        )
        let buildConfigurationName = pbxTarget.defaultBuildConfigurationName

        // // DEBUG BEGIN
        // fputs("*** CHUCK pbxTarget.name: \(String(reflecting: pbxTarget.name))\n", stderr)
        // fputs("*** CHUCK pbxTarget.schemeName: \(String(reflecting: pbxTarget.schemeName))\n", stderr)
        // fputs("*** CHUCK pbxTarget.isTestable: \(String(reflecting: pbxTarget.isTestable))\n", stderr)
        // fputs("*** CHUCK pbxTarget.isLaunchable: \(String(reflecting: pbxTarget.isLaunchable))\n", stderr)
        // // DEBUG END

        let buildEntries: [XCScheme.BuildAction.Entry]
        let testables: [XCScheme.TestableReference]
        if pbxTarget.isTestable {
            buildEntries = []
            testables = [.init(
                skipped: false,
                buildableReference: buildableReference
            )]
        } else {
            buildEntries = [.init(
                buildableReference: buildableReference,
                buildFor: [.running, .testing, .profiling, .archiving, .analyzing]
            )]
            testables = []
        }
        let buildableProductRunnable: XCScheme.BuildableProductRunnable? =
            pbxTarget.isLaunchable ?
            .init(buildableReference: buildableReference) : nil

        let buildAction = XCScheme.BuildAction(
            buildActionEntries: buildEntries,
            parallelizeBuild: true,
            buildImplicitDependencies: true
        )
        let testAction = XCScheme.TestAction(
            buildConfiguration: buildConfigurationName,
            macroExpansion: nil,
            testables: testables
        )
        let launchAction = XCScheme.LaunchAction(
            runnable: buildableProductRunnable,
            buildConfiguration: buildConfigurationName
        )
        let profileAction = XCScheme.ProfileAction(
            buildableProductRunnable: buildableProductRunnable,
            buildConfiguration: buildConfigurationName
        )
        let analyzeAction = XCScheme.AnalyzeAction(
            buildConfiguration: buildConfigurationName
        )
        let archiveAction = XCScheme.ArchiveAction(
            buildConfiguration: buildConfigurationName,
            revealArchiveInOrganizer: true
        )

        let scheme = XCScheme(
            name: pbxTarget.schemeName,
            lastUpgradeVersion: nil,
            version: nil,
            buildAction: buildAction,
            testAction: testAction,
            launchAction: launchAction,
            profileAction: profileAction,
            analyzeAction: analyzeAction,
            archiveAction: archiveAction,
            wasCreatedForAppExtension: nil
        )
        return scheme
    }
}
