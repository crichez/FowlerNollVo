//
//  File.swift
//  File
//
//  Created by Christopher Richez on 8/30/21.
//

import FowlerNollVo

/// A `FNVHasher` that implements the FNV-1a hash function with a 32-bit digest.
public struct FNV32a: FNVHasher {
    /// The hash of all data provided to the hasher.
    public var digest: UInt32
    
    /// Initializes a hasher, optionally providing an initial digest to iterate on.
    /// By default, the initial digest is the `offset` value.
    /// - Parameter digest: the initial digest to iterate from
    public init(digest: UInt32 = Self.offset) {
        self.digest = digest
    }
}
