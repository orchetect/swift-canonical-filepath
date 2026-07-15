# SwiftCanonicalFilePath

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-canonical-filepath%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/orchetect/swift-canonical-filepath) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Forchetect%2Fswift-canonical-filepath%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/orchetect/swift-canonical-filepath) [![License: MIT](http://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/orchetect/swift-canonical-filepath/blob/main/LICENSE)

Provides the `CanonicalFilePath` type for Swift on macOS.

This type wraps a `FilePath` instance from the System framework by performing file path canonicalization on it.

> [!NOTE]
>
> This type is only available on macOS as the API required is not available on other platforms.

## Motivation

Simple string comparison between two path strings is not sufficient to determine if they point to the same file system node.

Similarly, while the [`FilePath`](https://developer.apple.com/documentation/system/filepath) type provided by the macOS SDK's System framework is a useful type, it is still intended for abstract file path encapsulation and comparing two instances for equality will not indicate if the paths are identical in the file system.

The `CanonicalFilePath` type provided by this package standardizes the path upon initialization of the type by using path canonicalization API provided by the system. This allows two instances to be compared to determine if they point to the same file system node reliably.

The type also makes it clear that the file path has been canonicalized when the type is passed to methods or stored in variables.

## Getting Started

This library is available as a Swift Package Manager (SPM) package.

1. Add the **swift-canonical-filepath** repo as a dependency.

   ```swift
   .package(url: "https://github.com/orchetect/swift-canonical-filepath", from: "1.0.0")
   ```

2. Add **SwiftCanonicalFilePath** to your target.

   ```swift
   .product(name: "SwiftCanonicalFilePath", package: "swift-canonical-filepath")
   ```

3. Import **SwiftCanonicalFilePath** to use it.

   ```swift
   import SwiftCanonicalFilePath
   ```

## Documentation

See the [online documentation](https://swiftpackageindex.com/orchetect/swift-canonical-filepath/documentation) for library usage

## Author

Coded by a bunch of 🐹 hamsters in a trenchcoat that calls itself [@orchetect](https://github.com/orchetect).

## License

Licensed under the MIT license. See [LICENSE](https://github.com/orchetect/swift-canonical-filepath/blob/main/LICENSE) for details.

## Sponsoring

If you enjoy using this library and want to contribute to open-source financially, GitHub sponsorship is much appreciated. Feedback and code contributions are also welcome.

## Community & Support

Please do not email maintainers for technical support. Several options are available for issues and questions:

- Questions and feature ideas can be posted to [Discussions](https://github.com/orchetect/swift-canonical-filepath/discussions).
- If an issue is a verifiable bug with reproducible steps it may be posted in [Issues](https://github.com/orchetect/swift-canonical-filepath/issues).

## Contributions

Contributions are welcome. Posting in [Discussions](https://github.com/orchetect/swift-canonical-filepath/discussions) first prior to new submitting PRs for features or modifications is encouraged.

## Code Quality & AI Contribution Policy

In an effort to maintain a consistent level of code quality and safety, this repository was built by hand and is maintained without the use of AI code generation.

AI-assisted contributions are welcome, but must remain modest in scope, maintain the same degree of quality and care, and be thoroughly vetted before acceptance.
