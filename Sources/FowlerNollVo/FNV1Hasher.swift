//
//  FNV1Hasher.swift
//  
//
//  Created by Christopher Richez on 1/5/22.
//

/// A hasher that implements the Fowler-Noll-Vo-1 hash function.
public struct FNV1Hasher<Digest: FNVDigest>: FNVHasher {
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
        // Get an iterator for the data sequence
        var iterator = data.makeIterator()
        // Get the first byte of the sequence
        guard let firstByte = iterator.next() else {
            // If the sequence is empty, multiply by fnv_prime
            digest = digest &* .fnvPrime; return
        }
        // Combine the first byte manually
        digest = (digest &* .fnvPrime) ^ firstByte
        // Iterate over the rest of the bytes in the sequence
        while let byte = iterator.next() {
            digest = (digest &* .fnvPrime) ^ byte
        }
    }
}
