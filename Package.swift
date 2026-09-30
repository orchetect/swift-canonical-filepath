// swift-tools-version: 6.0

import Foundation
import PackageDescription

let package = Package(
    name: "swift-canonical-filepath",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: [
        .library(
            name: "SwiftCanonicalFilePath",
            targets: ["SwiftCanonicalFilePath"]
        )
    ],
    dependencies: [.package(url: "https://github.com/orchetect/swift-extensions", from: "3.0.0")],
    targets: [
        .target(
            name: "SwiftCanonicalFilePath",
            dependencies: [
                .product(name: "SwiftExtensions", package: "swift-extensions", condition: .when(platforms: [.macOS])),
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ]
        ),
        .testTarget(
            name: "SwiftCanonicalFilePathTests",
            dependencies: [
                "SwiftCanonicalFilePath"
            ]
        )
    ]
)

// MARK: - Utilities

func hasEnvironmentVariable(_ name: String) -> Bool {
    ProcessInfo.processInfo.environment[name] != nil
}

// MARK: - CI Pipeline

if hasEnvironmentVariable("GITHUB_ACTIONS") {
    for target in package.targets {
        if target.swiftSettings == nil { target.swiftSettings = [] }
        target.swiftSettings? += [.define("GITHUB_ACTIONS", .when(configuration: .debug))]
    }
}
