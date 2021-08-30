//
//  FNV64a.swift
//  FNV64a
//
//  Created by Christopher Richez on 8/30/21.
//

import FowlerNollVo

/// A `FNVHasher` that implements the FNV-1a hash function with a 64-bit digest.
public struct FNV64a: FNVHasher {
    /// The hash of all data provided to the hasher.
    public var digest: UInt64
    
    /// Initializes a hasher, optionally providing an initial digest to iterate on.
    /// By default, the initial digest is the `offset` value.
    /// - Parameter digest: the initial digest to iterate from
    public init(digest: UInt64 = Self.offset) {
        self.digest = digest
    }
}
