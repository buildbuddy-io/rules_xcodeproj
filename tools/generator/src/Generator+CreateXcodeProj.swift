import XcodeProj

extension Generator {
    /// Creates an `XcodeProj` for the given `PBXProj`.
    static func createXcodeProj(
        for pbxProj: PBXProj, 
        sharedData: XCSharedData? = nil
    ) -> XcodeProj {
        return XcodeProj(
            workspace: XCWorkspace(),
            pbxproj: pbxProj,
            sharedData: sharedData
        )
    }
}
