// swift-tools-version: 6.0

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

#if canImport(Foundation) || canImport(CoreFoundation)
    #if canImport(Foundation)
        import class Foundation.ProcessInfo

        func getEnvironmentVar(_ name: String) -> String? {
            ProcessInfo.processInfo.environment[name]
        }

    #elseif canImport(CoreFoundation)
        import CoreFoundation

        func getEnvironmentVar(_ name: String) -> String? {
            guard let rawValue = getenv(name) else { return nil }
            return String(utf8String: rawValue)
        }
    #endif

    func isEnvironmentVarTrue(_ name: String) -> Bool {
        guard let value = getEnvironmentVar(name)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        else { return false }
        return ["true", "yes", "1"].contains(value.lowercased())
    }

    // MARK: - CI Pipeline

    if isEnvironmentVarTrue("GITHUB_ACTIONS") {
        for target in package.targets.filter(\.isTest) {
            if target.swiftSettings == nil { target.swiftSettings = [] }
            target.swiftSettings? += [.define("GITHUB_ACTIONS", .when(configuration: .debug))]
        }
    }
#endif
