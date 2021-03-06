import XcodeProj
import XCTest

@testable import generator

class XCSchemeEnvironmentVariablesExtensionsTests: XCTestCase {
    func test_bazelLaunchVariables() throws {
        let result: [XCScheme.EnvironmentVariable] = .bazelLaunchVariables
        XCTAssertEqual(result.count, 2)

        let variableNames = Set(result.map(\.variable))
        XCTAssertEqual(
            variableNames,
            Set(["BUILD_WORKSPACE_DIRECTORY", "BUILD_WORKING_DIRECTORY"])
        )
    }
}
