//
//  URL+CanonicalFilePath.swift
//  SwiftCanonicalFilePath • https://github.com/orchetect/swift-canonical-filepath
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)

import Foundation
import System
import SwiftExtensions

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension URL {
    /// Returns the file URL as a new `CanonicalFilePath` instance.
    /// - Throws: Error if the URL is not a file URL.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public func asCanonicalFilePath(partial: Bool = false) throws -> CanonicalFilePath {
        // this init will validate URL as a file URL
        try CanonicalFilePath(canonicalizing: self, partial: partial)
    }

    /// Returns the file URL canonicalized as a new ``CanonicalFilePath`` instance if possible.
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

    /// Internal. Returns the file URL as a new `CanonicalFilePath` instance.
    /// Implements a workaround to prevent throwing or returning an Optional in scenarios where you
    /// can guarantee the URL is a file URL.
    ///
    /// - Parameters:
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    func asGuaranteedCanonicalFilePath(partial: Bool = false) -> CanonicalFilePath {
        assert(isFileURL)

        return CanonicalFilePath(canonicalizingIfPossible: asGuaranteedFilePath(), partial: partial)
    }
}

#endif
