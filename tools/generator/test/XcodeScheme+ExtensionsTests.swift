import XCTest

@testable import generator

class XcodeSchemeExtensionsTests: XCTestCase {
    func test_topLevelTargetLabels() throws {
        XCTFail("IMPLEMENT ME!")
    }

    // Labels
    let libLabel = "//examples/multiplatform/Lib:Lib"
    let toolLabel = "//examples/multiplatform/Tool:Tool"
    let iOSAppLabel = "//examples/multiplatform/iOSApp:iOSApp"
    let tvOSAppLabel = "//examples/multiplatform/tvOSApp:tvOSApp"
    let watchOSAppLabel = "//examples/multiplatform/watchOSApp:watchOSApp"

    // Configurations
    let iOSarm64Configuration = "ios-arm64-min15.0-applebin_ios-ios_arm64-dbg-ST-2427ca916465"
    let iOSx8664Configuration = "ios-x86_64-min15.0-applebin_ios-ios_x86_64-dbg-ST-d619bc5eae76"
    let macOSx8664Coniguration = "macos-x86_64-min11.0-applebin_macos-darwin_x86_64-dbg-ST-7373f6dcb398"
    let tvOSarm64Configuration = "tvos-arm64-min15.0-applebin_tvos-tvos_arm64-dbg-ST-90aac610cf68"
    let tvOSx8664Configuration = "tvos-x86_64-min15.0-applebin_tvos-tvos_x86_64-dbg-ST-9d824d5ada9f"

    let watchOSarm64Configuration = "watchos-arm64_32-min7.0-applebin_watchos-watchos_arm64_32-dbg-ST-ffdc9fd07085"
    let watchOSx8664Configuration = "watchos-x86_64-min7.0-applebin_watchos-watchos_x86_64-dbg-ST-cd006600ac60"
    let applebinMacOSDarwinx8664Configuration = "applebin_macos-darwin_x86_64-dbg-ST-7373f6dcb398"
    let applebiniOSiOSarm64Configuration = "applebin_ios-ios_arm64-dbg-ST-2427ca916465"
    let applebiniOSiOSx8664Configuration = "applebin_ios-ios_x86_64-dbg-ST-d619bc5eae76"
    let applebintvOStvOSarm64Configuration = "applebin_tvos-tvos_arm64-dbg-ST-90aac610cf68"
    let applebintvOStvOSx8664Configuration = "applebin_tvos-tvos_x86_64-dbg-ST-9d824d5ada9f"
    let applebinwatchOSwatchOSarm64Configuration = "applebin_watchos-watchos_arm64_32-dbg-ST-ffdc9fd07085"
    let applebinwatchOSwatchOSx8664Configuration = "applebin_watchos-watchos_x86_64-dbg-ST-cd006600ac60"

    // Platforms
    let appletvOSPlatform = Platform(
        name: "appletvos",
        os: .tvOS,
        arch: "arm64",
        minimumOsVersion: "15.0",
        environment: nil
    )
    let appletvSimulatorPlatform = Platform(
        name: "appletvsimulator",
        os: .tvOS,
        arch: "x86_64",
        minimumOsVersion: "15.0",
        environment: Optional("Simulator")
    )
    let iphoneOSPlatform = Platform(
        name: "iphoneos",
        os: .iOS,
        arch: "arm64",
        minimumOsVersion: "15.0",
        environment: nil
    )
    let iphoneSimulatorPlatform = Platform(
        name: "iphonesimulator",
        os: .iOS,
        arch: "x86_64",
        minimumOsVersion: "15.0",
        environment: Optional("Simulator")
    )
    let macOSPlatform = Platform(
        name: "macosx",
        os: .macOS,
        arch: "x86_64",
        minimumOsVersion: "11.0",
        environment: nil
    )
    let watchOSPlatform = Platform(
        name: "watchos",
        os: .watchOS,
        arch: "arm64_32",
        minimumOsVersion: "7.0",
        environment: nil
    )
    let watchSimulatorPlatform = Platform(
        name: "watchsimulator",
        os: .watchOS,
        arch: "x86_64",
        minimumOsVersion: "7.0",
        environment: Optional("Simulator")
    )

    lazy var libiOSarm64TargetID: TargetID = .init("\(libLabel) \(iOSarm64Configuration)")
    lazy var libiOSarm64Target = Target.mock(
        label: libLabel,
        configuration: iOSarm64Configuration,
        platform: iphoneOSPlatform,
        product: .init(
            type: .staticLibrary,
            name: "a",
            path: .generated("z/A.a")
        )
    )

    lazy var libiOSx8664TargetID: TargetID = .init("\(libLabel) \(iOSx8664Configuration)")
    lazy var libiOSx8664Target = Target.mock(
        label: libLabel,
        configuration: iOSx8664Configuration,
        platform: iphoneSimulatorPlatform,
        product: .init(
            type: .staticLibrary,
            name: "a",
            path: .generated("z/A.a")
        )
    )

    lazy var libtvOSarm64TargetID: TargetID = .init("\(libLabel) \(tvOSarm64Configuration)")
    lazy var libtvOSarm64Target = Target.mock(
        label: libLabel,
        configuration: tvOSarm64Configuration,
        platform: appletvOSPlatform,
        product: .init(
            type: .staticLibrary,
            name: "a",
            path: .generated("z/A.a")
        )
    )

    lazy var libtvOSx8664TargetID: TargetID = .init("\(libLabel) \(tvOSx8664Configuration)")
    lazy var libtvOSx8664Target = Target.mock(
        label: libLabel,
        configuration: tvOSx8664Configuration,
        platform: appletvSimulatorPlatform,
        product: .init(
            type: .staticLibrary,
            name: "a",
            path: .generated("z/A.a")
        )
    )

    lazy var libwatchOSarm64TargetID: TargetID = .init("\(libLabel) \(watchOSarm64Configuration)")
    lazy var libwatchOSarm64Target = Target.mock(
        label: libLabel,
        configuration: watchOSarm64Configuration,
        platform: watchOSPlatform,
        product: .init(
            type: .staticLibrary,
            name: "a",
            path: .generated("z/A.a")
        )
    )

    lazy var libwatchOSx8664TargetID: TargetID = .init("\(libLabel) \(watchOSx8664Configuration)")
    lazy var libwatchOSx8664Target = Target.mock(
        label: libLabel,
        configuration: watchOSx8664Configuration,
        platform: watchSimulatorPlatform,
        product: .init(
            type: .staticLibrary,
            name: "a",
            path: .generated("z/A.a")
        )
    )

    lazy var toolmacOSx8664TargetID: TargetID = .init(
        "\(toolLabel) \(applebinMacOSDarwinx8664Configuration)")
    lazy var toolmacOSx8664Target = Target.mock(
        label: toolLabel,
        configuration: applebinMacOSDarwinx8664Configuration,
        platform: macOSPlatform,
        product: .init(
            type: .commandLineTool,
            name: "a",
            path: .generated("z/A.a")
        )
    )

    let targets: [TargetID: Target] = [:]
}
