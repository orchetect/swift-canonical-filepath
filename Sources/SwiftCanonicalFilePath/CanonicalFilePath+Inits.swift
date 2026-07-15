//
//  CanonicalFilePath+Inits.swift
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
extension CanonicalFilePath {
    // MARK: Path String

    /// Creates a file path from a string and performs path canonicalization.
    ///
    /// - Parameters:
    ///   - string: Path string.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public init(canonicalizing string: String, partial: Bool = false) throws {
        let filePath = FilePath(string)
        try self.init(canonicalizing: filePath, partial: partial)
    }

    /// Creates a file path from a string and performs path canonicalization.
    /// If canonicalization fails, the path will be used as-is and the ``isCanonical`` property will be set to `false`.
    ///
    /// - Parameters:
    ///   - string: Path string.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    public init(canonicalizingIfPossible string: String, partial: Bool = false) {
        let filePath = FilePath(string)
        self.init(canonicalizingIfPossible: filePath, partial: partial)
    }

    // MARK: URL

    /// Creates a file path from a URL and performs path canonicalization.
    ///
    /// - Parameters:
    ///   - fileURL: File URL.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    @_disfavoredOverload
    public init(canonicalizing fileURL: URL, partial: Bool = false) throws {
        guard fileURL.isFileURL else { throw CocoaError(.fileNoSuchFile) }
        guard let filePath = FilePath(fileURL) else { throw CocoaError(.fileNoSuchFile) }
        try self.init(canonicalizing: filePath, partial: partial)
    }

    /// Creates a file path from a URL and performs path canonicalization.
    /// If canonicalization fails, the path will be used as-is and the ``isCanonical`` property will be set to `false`.
    ///
    /// - Parameters:
    ///   - fileURL: File URL.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    @_disfavoredOverload
    public init(canonicalizingIfPossible fileURL: URL, partial: Bool = false) {
        self.init(canonicalizingIfPossible: fileURL.path, partial: partial)
    }

    // MARK: FilePath

    /// Performs file path canonicalization.
    ///
    /// - Parameters:
    ///   - filePath: `FilePath` instance.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    @_disfavoredOverload
    public init(canonicalizing filePath: FilePath, partial: Bool = false) throws {
        wrapped = try filePath.canonicalized(partial: partial)
        isCanonical = true
    }

    /// Performs file path canonicalization.
    /// If canonicalization fails, the path will be used as-is and the ``isCanonical`` property will be set to `false`.
    ///
    /// - Parameters:
    ///   - filePath: `FilePath` instance.
    ///   - partial: When `true`, partial path canonicalization occurs by iterating each
    ///     path component one at a time. This allows for file paths that have a base path that exists
    ///     on disk but with one or more trailing path components that do not.
    ///     When `false`, the entire path is canonicalized in a single operation.
    @_disfavoredOverload
    public init(canonicalizingIfPossible filePath: FilePath, partial: Bool = false) {
        if let canonical = try? filePath.canonicalized(partial: partial) {
            wrapped = canonical
            isCanonical = true
        } else {
            wrapped = filePath
            isCanonical = false
        }
    }
}

#endif
