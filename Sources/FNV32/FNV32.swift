//
//  FNV32.swift
//  FNV32
//
//  Created by Christopher Richez on 8/30/21.
//

import FowlerNollVo

/// A `FNVHasher` that implements the old FNV-1 hash function with a 32-bit digest.
public struct FNV32: FNVHasher {
    /// The hash of all data provided to the hasher.
    public var digest: UInt32
    
    /// Initializes a hasher, optionally providing an initial digest to iterate on.
    /// By default, the initial digest is the `offset` value.
    /// - Parameter digest: the initial digest to iterate from
    public init(digest: UInt32 = Self.offset) {
        self.digest = digest
    }
    /// A hashing method that implements the old FNV-1 function.
    /// - Parameter data: any sequence of `UInt8` values
    public mutating func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8 {
        for byte in data {
            digest = (digest &* Self.prime) ^ UInt32(truncatingIfNeeded: byte)
        }
    }
}
