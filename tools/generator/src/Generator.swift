import PathKit
import XcodeProj

/// A class that generates and writes to disk an Xcode project.
///
/// The `Generator` class is stateless. It can be used to generate multiple
/// projects. The `generate()` method is passed all the inputs needed to
/// generate a project.
class Generator {
    static let defaultEnvironment = Environment(
        createProject: Generator.createProject,
        processTargetMerges: Generator.processTargetMerges,
        createFilesAndGroups: Generator.createFilesAndGroups,
        createProducts: Generator.createProducts,
        populateMainGroup: populateMainGroup,
        disambiguateTargets: Generator.disambiguateTargets,
        addTargets: Generator.addTargets,
        setTargetConfigurations: Generator.setTargetConfigurations,
        setTargetDependencies: Generator.setTargetDependencies,
        createXcodeProj: Generator.createXcodeProj,
        writeXcodeProj: Generator.writeXcodeProj
    )

    let environment: Environment
    let logger: Logger

    init(
        environment: Environment = Generator.defaultEnvironment, 
        logger: Logger
    ) {
        self.logger = logger
        self.environment = environment
    }

    /// Generates an Xcode project for a given `Project`.
    func generate(
        project: Project,
        projectRootDirectory: Path,
        externalDirectory: Path,
        generatedDirectory: Path,
        internalDirectoryName: String,
        workspaceOutputPath: Path,
        outputPath: Path
    ) throws {
        let pbxProj = environment.createProject(project, projectRootDirectory)
        guard let pbxProject = pbxProj.rootObject else {
            throw PreconditionError(message: """
`rootObject` not set on `pbxProj`
""")
        }
        let mainGroup: PBXGroup = pbxProject.mainGroup

        var targets = project.targets
        let invalidMerges = try environment.processTargetMerges(
            &targets,
            project.potentialTargetMerges,
            project.requiredLinks
        )

        for invalidMerge in invalidMerges {
            guard let srcTarget = targets[invalidMerge.source] else {
                throw PreconditionError(
                    message: """
                    Expected the invalid merge source to exist.  \(String(reflecting: invalidMerge))
                    """)
            }
            for destination in invalidMerge.destinations {
                guard let desTarget = targets[destination] else {
                    throw PreconditionError(message: """
                    Expected the destination target to exist. \(String(reflecting: destination))
                    """)
                }
                logger.logWarning("""
Was unable to merge "\(srcTarget.label) \
(\(srcTarget.configuration))" into \
"\(desTarget.label) \
(\(desTarget.configuration))"
""")
            }
        }

        let filePathResolver = FilePathResolver(
            externalDirectory: externalDirectory,
            generatedDirectory: generatedDirectory,
            internalDirectoryName: internalDirectoryName,
            workspaceOutputPath: workspaceOutputPath
        )

        let (files, rootElements) = try environment.createFilesAndGroups(
            pbxProj,
            targets,
            project.extraFiles,
            filePathResolver
        )
        let (products, productsGroup) = environment.createProducts(
            pbxProj,
            targets
        )
        environment.populateMainGroup(
            mainGroup,
            pbxProj,
            rootElements,
            productsGroup
        )

        let disambiguatedTargets = environment.disambiguateTargets(targets)
        let pbxTargets = try environment.addTargets(
            pbxProj,
            disambiguatedTargets,
            products,
            files,
            filePathResolver,
            project.label
        )
        try environment.setTargetConfigurations(
            pbxProj,
            disambiguatedTargets,
            pbxTargets,
            filePathResolver
        )
        try environment.setTargetDependencies(
            disambiguatedTargets,
            pbxTargets
        )

         let xcodeProj = environment.createXcodeProj(pbxProj)
         try environment.writeXcodeProj(
            xcodeProj,
            files,
            internalDirectoryName,
            outputPath
         )
    }
}

/// When a potential merge wasn't valid, then the ids of the targets involved
/// are returned in this `struct`.
struct InvalidMerge: Equatable {
    let source: TargetID
    let destinations: Set<TargetID>
}
