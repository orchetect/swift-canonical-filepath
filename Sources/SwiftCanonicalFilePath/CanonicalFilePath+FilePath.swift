//
//  CanonicalFilePath+FilePath.swift
//  SwiftCanonicalFilePath • https://github.com/orchetect/swift-canonical-filepath
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation) && canImport(System)

import Foundation
import System
import SwiftExtensions

// MARK: - FilePath Native Forwarded Methods & Properties

// Note that some of these methods are INTENTIONALLY READ-ONLY even though `FilePath` supports setters for some of them.
// See the `CanonicalFilePath` inline documentation for the reason for offering these forwarding methods as read-only.

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath {
    /// View the non-root components that make up this path.
    public var components: FilePath.ComponentView {
        wrapped.components
    }

    /// The extension of the file or directory last component.
    public var `extension`: String? {
        wrapped.extension
    }

    /// Returns `true` if this path uniquely identifies the location of a file without reference to
    /// an additional starting location.
    public var isAbsolute: Bool {
        wrapped.isAbsolute
    }

    /// Whether this path is empty.
    public var isEmpty: Bool {
        wrapped.isEmpty
    }

    /// Whether the path is in lexical-normal form, that is `.` and `..` components have been collapsed
    /// lexically (i.e. without following symlinks).
    public var isLexicallyNormal: Bool {
        wrapped.isLexicallyNormal
    }

    /// Returns `true` if this path is not absolute (see ``isAbsolute``).
    public var isRelative: Bool {
        wrapped.isRelative
    }

    /// Returns the final component of the path. Returns `nil` if the path is empty or only contains a root.
    public var lastComponent: FilePath.Component? {
        wrapped.lastComponent
    }

    /// Returns the root of a path if there is one, otherwise `nil`.
    public var root: FilePath.Root? {
        wrapped.root
    }

    /// The non-extension portion of the file or directory last component.
    public var stem: String? {
        wrapped.stem
    }

    /// Creates a string by interpreting the path’s content as UTF-8 on Unix and UTF-16 on Windows.
    public var string: String {
        wrapped.string
    }

    /// The length of the file path, excluding the null terminator.
    public var length: Int {
        wrapped.length
    }

    /// Returns whether other is a suffix of `self`, only considering whole path components.
    public func ends(with other: FilePath) -> Bool {
        wrapped.ends(with: other)
    }

    /// Returns whether other is a suffix of `self`, only considering whole path components.
    public func ends(with other: CanonicalFilePath) -> Bool {
        wrapped.ends(with: other.wrapped)
    }

    /// Returns whether other is a prefix of `self`, only considering whole path components.
    public func starts(with other: FilePath) -> Bool {
        wrapped.starts(with: other)
    }

    /// Returns whether other is a prefix of `self`, only considering whole path components.
    public func starts(with other: CanonicalFilePath) -> Bool {
        wrapped.starts(with: other.wrapped)
    }

    /// Append the contents of `other`, ignoring any spurious leading separators.
    public mutating func append(_ other: String) {
        let newPath = wrapped.appending(other)
        self = CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
    }

    /// Non-mutating version of ``append(_:)-(String))``.
    public func appending(_ other: String) -> CanonicalFilePath {
        let newPath = wrapped.appending(other)
        return CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
    }

    /// Append a component on to the end of this path.
    public mutating func append(_ component: FilePath.Component) {
        let newPath = wrapped.appending(component)
        self = CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
    }

    /// Non-mutating version of ``append(_:)-(FilePath.Component)``.
    public func appending(_ component: FilePath.Component) -> CanonicalFilePath {
        let newPath = wrapped.appending(component)
        return CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
    }

    /// Append components on to the end of this path.
    public mutating func append(_ components: some Collection<FilePath.Component>) {
        let newPath = wrapped.appending(components)
        self = CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
    }

    /// Non-mutating version of ``append(_:)-(C)``.
    public func appending(_ components: some Collection<FilePath.Component>) -> CanonicalFilePath {
        let newPath = wrapped.appending(components)
        return CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
    }

    /// In-place mutating variant of ``removingLastComponent()``.
    @discardableResult
    public mutating func removeLastComponent() -> Bool {
        var newPath = wrapped
        let result = newPath.removeLastComponent()

        if isCanonical {
            // since we are only removing the last path component and not adding or mutating,
            // we can skip re-canonicalizing the new path
            self = CanonicalFilePath(verbatim: newPath, isCanonical: isCanonical)
        } else {
            // it's possible that by re-canonicalizing it may successfully become canonical
            self = CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
        }
        return result
    }

    /// Creates a new path with everything up to but not including `lastComponent`.
    public func removingLastComponent() -> CanonicalFilePath {
        let newPath = wrapped.removingLastComponent()

        if isCanonical {
            // since we are only removing the last path component and not adding or mutating,
            // we can skip re-canonicalizing the new path
            return CanonicalFilePath(verbatim: newPath, isCanonical: isCanonical)
        } else {
            // it's possible that by re-canonicalizing it may successfully become canonical
            return CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
        }
    }
}

// MARK: - FilePath SwiftExtensions-Defined Forwarded Methods & Properties

@available(macOS 12.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
extension CanonicalFilePath {
    // MARK: - FilePath & URL Interop

    /// Returns the file path as a new file `URL` instance.
    @available(macOS 12.0, *)
    @_disfavoredOverload
    public func asURL() -> URL {
        wrapped.asURL()
    }

    /// Returns the file path as a new file `URL` instance.
    @available(macOS 13.0, *)
    public func asURL(directoryHint: URL.DirectoryHint = .inferFromPath) -> URL {
        wrapped.asURL(directoryHint: directoryHint)
    }

    // MARK: - Path Manipulation

    /// Return a new path by mutating the file name (last path component).
    ///
    /// If path components are empty, this has no effect.
    @available(macOS 12.0, *)
    @_disfavoredOverload
    public func mutatingLastPathComponent(
        _ transform: (_ component: FilePath.Component) -> String
    ) -> Self {
        guard lastComponent != nil else { return self }
        let newPath = wrapped.mutatingLastPathComponent(transform)
        return CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
    }

    /// Return a new path by mutating the file name (last path component) excluding extension.
    ///
    /// If path components are empty, this has no effect.
    @available(macOS 12.0, *)
    @_disfavoredOverload
    public func mutatingLastPathComponentExcludingExtension(
        _ transform: (_ baseFilename: String) -> String
    ) -> Self {
        guard lastComponent != nil else { return self }
        let newPath = wrapped.mutatingLastPathComponentExcludingExtension(transform)
        return CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
    }

    /// Return a new path by appending a string to the file name (last path component) before the
    /// extension.
    ///
    /// ie:
    ///
    /// ```swift
    /// let path = CanonicalFilePath("/Users/user/file.txt")
    /// let path2 = path.appendingToLastPathComponentBeforeExtension("-2")
    /// path2.string // "/Users/user/file-2.txt"
    /// ```
    ///
    /// If path components are empty, this has no effect.
    @available(macOS 12.0, *)
    public func appendingToLastPathComponentBeforeExtension(
        _ string: String
    ) -> Self {
        guard lastComponent != nil else { return self }
        let newPath = wrapped.appendingToLastPathComponentBeforeExtension(string)
        return CanonicalFilePath(canonicalizingIfPossible: newPath, partial: true)
    }

    // MARK: - File / Folder Metadata

    /// Returns whether the file/folder exists.
    /// Convenience proxy for Foundation `FileManager` `fileExists` method.
    ///
    /// - Will return `false` if used on a symlink and the symlink's original file does not exist.
    /// - Will still return `true` if used on an alias and the alias' original file does not exist.
    @available(macOS 12.0, *)
    public var fileExists: Bool {
        wrapped.fileExists
    }

    /// Returns whether the file path is a directory by querying the local file system.
    ///
    /// - Returns: `true` if the path exists and is a folder.
    ///   `false` if the path is not a folder or the path does not exist.
    @available(macOS 12.0, *)
    public var isDirectory: Bool {
        wrapped.isDirectory
    }

    /// Returns `true` if the path points to the same file system node as another path.
    /// This is more reliable than comparing simple equality of two `FilePath` instances, as this method
    /// will account for mismatched case and will resolve the paths as needed in order to perform
    /// the comparison.
    ///
    /// > Note:
    /// > This method is only available on macOS as the API required is not available on other
    /// > platforms.
    ///
    /// - Throws: Error if there was a problem reading the file system.
    public func isEqualFileNode(as otherFilePath: FilePath) throws -> Bool {
        try wrapped.isEqualFileNode(as: otherFilePath)
    }

    /// Returns `true` if the path points to the same file system node as another path.
    /// This is more reliable than comparing simple equality of two `FilePath` instances, as this method
    /// will account for mismatched case and will resolve the paths as needed in order to perform
    /// the comparison.
    ///
    /// > Note:
    /// > This method is only available on macOS as the API required is not available on other
    /// > platforms.
    ///
    /// - Throws: Error if there was a problem reading the file system.
    public func isEqualFileNode(as otherFilePath: CanonicalFilePath) throws -> Bool {
        try wrapped.isEqualFileNode(as: otherFilePath.wrapped)
    }

    // MARK: - File Operations

    /// Attempts to first move a file to the Trash if possible, otherwise attempts to delete the
    /// file.
    ///
    /// If the file was moved to the trash, the new resulting path is returned.
    ///
    /// If the file was deleted, `nil` is returned.
    ///
    /// If both operations were unsuccessful, an error is thrown.
    @available(macOS 13.0, *)
    @discardableResult
    public func trashOrDelete() throws -> CanonicalFilePath? {
        try wrapped.trashOrDelete()?.asCanonicalFilePathIfPossible()
    }

    /// If the file path is a file or folder that exists on disk, the file name (last path component
    /// prior to extension) is uniqued by appending the first number in `2...` that results in a file
    /// name that does not exist on disk.
    ///
    /// - Parameter suffix: Formatting of the suffix. The incrementing counter number is passed in
    ///   and must be used in the body of the closure. The closure must not return a static value.
    ///
    ///   For example, given a file named "MyFile.txt" that exists on disk:
    ///
    ///   - `" \($0)"` produces "MyFile 2.txt", "MyFile 3.txt", etc.
    ///   - `"-\($0)"` produces "MyFile-2.txt", "MyFile-3.txt", etc.
    ///   - `" (\($0))"` produces "MyFile (2).txt", "MyFile (3).txt", etc.
    @available(macOS 12.0, *)
    public mutating func unique(
        suffix: (_ counter: Int) -> String = { " \($0)" }
    ) {
        self = uniqued(suffix: suffix)
    }

    /// If the file path is a file or folder that exists on disk, the file name (last path component
    /// prior to extension) is uniqued by appending the first number in `2...` that results in a file
    /// name that does not exist on disk.
    ///
    /// - Parameter suffix: Formatting of the suffix. The incrementing counter number is passed in
    ///   and must be used in the body of the closure. The closure must not return a static value.
    ///
    ///   For example, given a file named "MyFile.txt" that exists on disk:
    ///
    ///   - `" \($0)"` produces "MyFile 2.txt", "MyFile 3.txt", etc.
    ///   - `"-\($0)"` produces "MyFile-2.txt", "MyFile-3.txt", etc.
    ///   - `" (\($0))"` produces "MyFile (2).txt", "MyFile (3).txt", etc.
    @available(macOS 12.0, *)
    public func uniqued(
        suffix: (_ counter: Int) -> String = { " \($0)" }
    ) -> CanonicalFilePath {
        let newPath = wrapped.uniqued(suffix: suffix)
        // since we are only changing the filename and not the path, we can skip re-canonicalizing the new path
        return CanonicalFilePath(verbatim: newPath, isCanonical: isCanonical)
    }

    // MARK: - Finder Aliases

    /// Convenience method to test if a file path is a Finder alias.
    @available(macOS 13.0, *)
    public var isFinderAlias: Bool {
        wrapped.isFinderAlias
    }

    /// Creates an alias of the base file or folder `at` the supplied target location. Will
    /// overwrite existing target path if it exists.
    @available(macOS 13.0, *)
    @_disfavoredOverload
    public func createFinderAlias(at path: FilePath) throws {
        try wrapped.createFinderAlias(at: path)
    }

    /// Creates an alias of the base file or folder `at` the supplied target location. Will
    /// overwrite existing target path if it exists.
    @available(macOS 13.0, *)
    public func createFinderAlias(at path: CanonicalFilePath) throws {
        try wrapped.createFinderAlias(at: path.wrapped)
    }

    /// If the path is a Finder alias, its resolved path is returned regardless whether it exists or not.
    ///
    /// `nil` will be returned if any of the following is true for `self`:
    /// - is not a Finder alias or does not exist, or
    /// - is a symbolic link or a hard link and not a Finder alias, or
    /// - does not exist.
    @available(macOS 13.0, *)
    public var resolvedFinderAlias: CanonicalFilePath? {
        wrapped.resolvedFinderAlias?.asCanonicalFilePathIfPossible()
    }

    // MARK: - SymLinks

    /// Convenience method to test if a path is a symbolic link pointing to another file/folder,
    /// and not an actual file/folder itself.
    ///
    /// - Throws: Error if there was a problem querying the path's file system attributes.
    @available(macOS 12.0, *)
    public var isSymLink: Bool {
        get throws { try wrapped.isSymLink }
    }

    /// Convenience method to test if a file path is a symbolic link pointing to `file`.
    ///
    /// - Returns: `true` even if original file does not exist. This is possible because a symbolic link
    ///   is its own file system node that points to another, regardless if the original exists or not.
    /// - Throws: `nil` if the path is not a properly formatted or there was a problem querying the file system.
    @available(macOS 12.0, *)
    @_disfavoredOverload
    public func isSymLink(of path: FilePath) throws -> Bool {
        try wrapped.isSymLink(of: path)
    }

    /// Convenience method to test if a file path is a symbolic link pointing to `file`.
    ///
    /// - Returns: `true` even if original file does not exist. This is possible because a symbolic link
    ///   is its own file system node that points to another, regardless if the original exists or not.
    /// - Throws: `nil` if the path is not a properly formatted or there was a problem querying the file system.
    @available(macOS 12.0, *)
    public func isSymLink(of path: CanonicalFilePath) throws -> Bool {
        try wrapped.isSymLink(of: path.wrapped)
    }

    /// Creates a symbolic link (symlink) of the base path file or folder `at` the supplied target
    /// location.
    ///
    /// - Returns `true` if new symlink gets created.
    /// - Returns `false` if destination already exists or if the symlink already exists.
    @available(macOS 13.0, *)
    @_disfavoredOverload
    public func createSymLink(at path: FilePath) throws {
        try wrapped.createSymLink(at: path)
    }

    /// Creates a symbolic link (symlink) of the base path file or folder `at` the supplied target
    /// location.
    ///
    /// - Returns `true` if new symlink gets created.
    /// - Returns `false` if destination already exists or if the symlink already exists.
    @available(macOS 13.0, *)
    public func createSymLink(at path: CanonicalFilePath) throws {
        try wrapped.createSymLink(at: path.wrapped)
    }

    // MARK: - Static

    /// The working directory of the current process.
    /// Calling this property will issue a `getcwd` syscall.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static func currentDirectory() -> CanonicalFilePath {
        URL.currentDirectory().asGuaranteedCanonicalFilePath()
    }

    /// The home directory for the current user (~/).
    /// Complexity: O(1)
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var homeDirectory: CanonicalFilePath {
        URL.homeDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Returns the home directory for the specified user.
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static func homeDirectory(forUser user: String) -> CanonicalFilePath? {
        URL.homeDirectory(forUser: user)?.asGuaranteedCanonicalFilePath()
    }

    /// The temporary directory for the current user.
    /// Complexity: O(1)
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var temporaryDirectory: CanonicalFilePath {
        URL.temporaryDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Discardable cache files directory for the
    /// current user. (~/Library/Caches).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var cachesDirectory: CanonicalFilePath {
        URL.cachesDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Supported applications (/Applications).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var applicationDirectory: CanonicalFilePath {
        URL.applicationDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Various user-visible documentation, support, and configuration
    /// files for the current user (~/Library).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var libraryDirectory: CanonicalFilePath {
        URL.libraryDirectory.asGuaranteedCanonicalFilePath()
    }

    /// User home directories (/Users).
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var userDirectory: CanonicalFilePath {
        URL.userDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Documents directory for the current user (~/Documents)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var documentsDirectory: CanonicalFilePath {
        URL.documentsDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Desktop directory for the current user (~/Desktop)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var desktopDirectory: CanonicalFilePath {
        URL.desktopDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Application support files for the current
    /// user (~/Library/Application Support)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var applicationSupportDirectory: CanonicalFilePath {
        URL.applicationSupportDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Downloads directory for the current user (~/Downloads)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var downloadsDirectory: CanonicalFilePath {
        URL.downloadsDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Movies directory for the current user (~/Movies)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var moviesDirectory: CanonicalFilePath {
        URL.moviesDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Music directory for the current user (~/Music)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var musicDirectory: CanonicalFilePath {
        URL.musicDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Pictures directory for the current user (~/Pictures)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var picturesDirectory: CanonicalFilePath {
        URL.picturesDirectory.asGuaranteedCanonicalFilePath()
    }

    /// The user’s Public sharing directory (~/Public)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, tvOS 16.0, watchOS 9.0, *)
    public static var sharedPublicDirectory: CanonicalFilePath {
        URL.sharedPublicDirectory.asGuaranteedCanonicalFilePath()
    }

    /// Trash directory for the current user (~/.Trash)
    /// Complexity: O(n) where n is the number of significant directories
    /// specified by `FileManager.SearchPathDirectory`
    @available(macOS 13.0, iOS 16.0, *)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static var trashDirectory: CanonicalFilePath {
        URL.trashDirectory.asGuaranteedCanonicalFilePath()
    }
}

#endif
