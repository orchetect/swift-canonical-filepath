//
//  CanonicalFilePath.swift
//  SwiftCanonicalFilePath • https://github.com/orchetect/swift-canonical-filepath
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation) && canImport(System)

import Foundation
import System
import SwiftExtensions

/// Wraps a `FilePath` instance by performing file path canonicalization on it.
///
/// This type makes it clear that the file path has been canonicalized, which makes comparing two instances more reliable.
///
/// Because of that, methods to mutate the path are not available. If you want to mutate the path, extract the ``wrapped``
/// `FilePath` instance and mutate it as needed. To re-canonicalize the path, you can then construct a new
/// `CanonicalFilePath` instance from it once more.
///
/// > Note:
/// > This type is only available on macOS as the API required is not available on other platforms.
@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public struct CanonicalFilePath {
    /// If path canonicalization was successful at the time of initialization, this property will return `true`.
    public let isCanonical: Bool

    /// The underlying `FilePath` instance.
    public let wrapped: FilePath

    /// Internal initializer that should only be called when you can guarantee the file path is already canonical.
    init(verbatim: FilePath, isCanonical: Bool) {
        wrapped = verbatim
        self.isCanonical = isCanonical
    }
}


// MARK: - Equatable

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs.isEqual(to: rhs) {
        case .equal, .equalAfterRecanonicalization(partial: _): true
        case .notEqual: false
        }
    }

    public enum ComparisonResult: Equatable, Hashable, Sendable {
        /// Both instances evaluated as equal as-is.
        case equal

        /// Both instances did not evaluate as equal as-is, but evaluated as equal after re-canonicalizing one or both instances.
        ///
        /// - Parameters:
        ///   - partial: If `true`, partial recanonicalization was required to achieve an equal evaluation.
        case equalAfterRecanonicalization(partial: Bool)

        /// The instances are not equal, and remain not equal even after re-canonicalization.
        case notEqual
    }

    /// Returns a comparison result after evaluating both instances, re-canonicalizing if initial comparison evaluates as not equal.
    public func isEqual(to other: Self) -> ComparisonResult {
        // if both were successfully canonicalized, compare directly
        if isCanonical, other.isCanonical {
            return (wrapped == other.wrapped) ? .equal : .notEqual
        }

        // otherwise attempt to canonicalize (non-partial) any that were not successfully canonicalized
        let refreshedSelf = isCanonical ? self : CanonicalFilePath(canonicalizingIfPossible: wrapped, partial: false)
        let refreshedOther = other.isCanonical ? other : CanonicalFilePath(canonicalizingIfPossible: other.wrapped, partial: false)
        if refreshedSelf.wrapped == refreshedOther.wrapped {
            let isChanged = (isCanonical != refreshedSelf.isCanonical) || (other.isCanonical != refreshedOther.isCanonical)
            return isChanged ? .equalAfterRecanonicalization(partial: false) : .equal
        }

        // otherwise attempt to canonicalize (partial) any that were not successfully canonicalized
        let refreshedSelf2 = isCanonical ? self : CanonicalFilePath(canonicalizingIfPossible: wrapped, partial: true)
        let refreshedOther2 = other.isCanonical ? other : CanonicalFilePath(canonicalizingIfPossible: other.wrapped, partial: true)
        if refreshedSelf2.wrapped == refreshedOther2.wrapped {
            let isChanged = (isCanonical != refreshedSelf2.isCanonical) || (other.isCanonical != refreshedOther2.isCanonical)
            return isChanged ? .equalAfterRecanonicalization(partial: true) : .equal
        }

        return .notEqual
    }
}

// MARK: - Hashable

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: Hashable { }

// MARK: - Sendable

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: Sendable { }

// MARK: - Codable

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: Codable {
    public init(from decoder: any Decoder) throws {
        let decoded = try FilePath(from: decoder)

        // we're not encoding `isCanonical` flag, so safest course is to attempt to re-canonicalize it
        self.init(canonicalizingIfPossible: decoded)
    }

    public func encode(to encoder: any Encoder) throws {
        // act as a proxy, and don't encode `isCanonical` flag
        try wrapped.encode(to: encoder)
    }
}

// MARK: - CustomStringConvertible / CustomDebugStringConvertible

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: CustomStringConvertible {
    public var description: String {
        wrapped.description
    }
}

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath: CustomDebugStringConvertible {
    public var debugDescription: String {
        wrapped.debugDescription
    }
}

#endif
