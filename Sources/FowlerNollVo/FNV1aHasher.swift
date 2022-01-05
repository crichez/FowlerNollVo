//
//  FNV1aHasher.swift
//  FNV1aHasher
//
//  Created by Christopher Richez on August 30th 2021
//

/// A hasher that implements the Fowler-Noll-Vo-1a hash function.
public struct FNV1aHasher<Digest: FNVDigest>: FNVHasher {
    /// The current digest produced by this hasher.
    public var digest: Digest
    
    /// Initializes a hasher.
    public init() { self.digest = .fnvOffset }
    
    /// Hashes the provided ``FNVHashable`` elements.
    public mutating func combine<T>(_ data: T) where T : FNVHashable {
        data.hash(into: &self)
    }
    
    /// Feeds the provided data to the hasher.
    public mutating func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8 {
        for byte in data {
            digest = (digest ^ byte) &* .fnvPrime
        }
    }
}
