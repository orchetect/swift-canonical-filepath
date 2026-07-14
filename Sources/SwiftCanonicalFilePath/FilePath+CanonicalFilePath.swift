//
//  FilePath+CanonicalFilePath.swift
//  SwiftCanonicalFilePath • https://github.com/orchetect/swift-canonical-filepath
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation) && canImport(System)

import Foundation
import System
import SwiftExtensions

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension FilePath {
    /// Returns the file path canonicalized as a new ``CanonicalFilePath`` instance.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public func asCanonicalFilePath(partial: Bool = false) throws -> CanonicalFilePath {
        try CanonicalFilePath(canonicalizing: self, partial: partial)
    }

    /// Returns the file path canonicalized as a new ``CanonicalFilePath`` instance if possible.
    /// If canonicalization fails, the file path will be used as-is (unmodified) and the ``isCanonical`` property will be set to `false`.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public func asCanonicalFilePathIfPossible(partial: Bool = false) -> CanonicalFilePath {
        CanonicalFilePath(canonicalizingIfPossible: self, partial: partial)
    }
}

#endif
