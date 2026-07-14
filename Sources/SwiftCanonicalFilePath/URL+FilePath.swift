//
//  URL+FilePath.swift
//  SwiftCanonicalFilePath • https://github.com/orchetect/swift-canonical-filepath
//  © 2026 Steffan Andrews • Licensed under MIT License
//

#if canImport(Foundation) && canImport(System)

import Foundation
import System

@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension URL {
    // Note: This method is copied from SwiftExtensions 2.3.2.

    /// Internal. Returns the file URL as a new `FilePath` instance.
    /// Implements a workaround to prevent throwing or returning an Optional in scenarios where you
    /// can guarantee the URL is a file URL.
    func asGuaranteedFilePath() -> FilePath {
        assert(isFileURL)

        if let path = FilePath(self) { return path }

        // alternative method:
        // FilePath throws an exception if we supply it with components that include the root
        let components = pathComponents.drop { $0 == "/" }
        return FilePath(root: "/", components.map(FilePath.Component.init))
    }
}

#endif
