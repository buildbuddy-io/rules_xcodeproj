import CustomDump
import XCTest

@testable import generator

final class BuildSettingConditionalTests: XCTestCase {
    static let conditionals: [String: BuildSettingConditional] = [
        "A": .init(platform: .init(
            name: "A",
            os: .iOS,
            arch: "arm64",
            minimumOsVersion: "11.0",
            environment: "Simulator"
        )),
        "B": .init(platform: .init(
            name: "B",
            os: .iOS,
            arch: "x86_64",
            minimumOsVersion: "11.0",
            environment: "Simulator"
        )),
        "C": .init(platform: .init(
            name: "C",
            os: .iOS,
            arch: "arm64",
            minimumOsVersion: "11.0",
            environment: nil
        )),
        "any": .any,
    ]

    func test_comparable() {
        // Arrange

        let conditionalA = Self.conditionals["A"]!
        let conditionalAny = BuildSettingConditional.any

        // Assert

        XCTAssertFalse(conditionalA < conditionalA)
        XCTAssertEqual(conditionalA, conditionalA)
        XCTAssertFalse(conditionalA > conditionalA)

        XCTAssertFalse(conditionalAny < conditionalAny)
        XCTAssertEqual(conditionalAny, conditionalAny)
        XCTAssertFalse(conditionalAny > conditionalAny)
    }

    func test_sort() {
        // Arrange

        let conditionals = Self.conditionals
        let expectedSortedConditionals = [
            conditionals["any"]!,
            conditionals["A"]!,
            conditionals["B"]!,
            conditionals["C"]!,
        ]

        // Act

        let sortedConditionals = conditionals.values.sorted()

        // Assert

        XCTAssertNoDifference(sortedConditionals, expectedSortedConditionals)
    }

    func test_conditionalize_normal() {
        // Arrange

        let buildSettingKey = "SOME_SETTING"
        let conditionals = Self.conditionals
        let expectedConditionalizedKeys = [
            "SOME_SETTING",
            "SOME_SETTING[sdk=A][arch=arm64]",
            "SOME_SETTING[sdk=B][arch=x86_64]",
            "SOME_SETTING[sdk=C][arch=arm64]",
        ]

        // Act

        let conditionalizedKeys = [
            conditionals["any"]!.conditionalize(buildSettingKey),
            conditionals["A"]!.conditionalize(buildSettingKey),
            conditionals["B"]!.conditionalize(buildSettingKey),
            conditionals["C"]!.conditionalize(buildSettingKey),
        ]

        // Assert

        XCTAssertNoDifference(conditionalizedKeys, expectedConditionalizedKeys)
    }

    func test_conditionalize_archs() {
        // Arrange

        let buildSettingKey = "ARCHS"
        let conditionals = Self.conditionals
        let expectedConditionalizedKeys = [
            "ARCHS",
            "ARCHS[sdk=A]",
            "ARCHS[sdk=B]",
            "ARCHS[sdk=C]",
        ]

        // Act

        let conditionalizedKeys = [
            conditionals["any"]!.conditionalize(buildSettingKey),
            conditionals["A"]!.conditionalize(buildSettingKey),
            conditionals["B"]!.conditionalize(buildSettingKey),
            conditionals["C"]!.conditionalize(buildSettingKey),
        ]

        // Assert

        XCTAssertNoDifference(conditionalizedKeys, expectedConditionalizedKeys)
    }

    func test_conditionalize_sdkroot() {
        // Arrange

        let buildSettingKey = "SDKROOT"
        let conditionals = Self.conditionals
        let expectedConditionalizedKeys = [
            "SDKROOT",
            "SDKROOT[arch=arm64]",
            "SDKROOT[arch=x86_64]",
            "SDKROOT[arch=arm64]",
        ]

        // Act

        let conditionalizedKeys = [
            conditionals["any"]!.conditionalize(buildSettingKey),
            conditionals["A"]!.conditionalize(buildSettingKey),
            conditionals["B"]!.conditionalize(buildSettingKey),
            conditionals["C"]!.conditionalize(buildSettingKey),
        ]

        // Assert

        XCTAssertNoDifference(conditionalizedKeys, expectedConditionalizedKeys)
    }
}
