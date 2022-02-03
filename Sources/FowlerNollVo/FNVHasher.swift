//
//  FNVHasher.swift
//  
//
//  Created by Christopher Richez on 1/5/22.
//

/// A value that uses a Fowler-Noll-Vo hash function on ingested data to produce a digest.
///
/// A `FNVHasher` ingests data in two ways:
/// 1. From a ``FNVHashable`` value using the ``combine(_:)-8ngc`` method
/// 2. From a `Sequence` of `UInt8` bytes using the ``combine(_:)-8ngc`` method
///
/// Ingested data is hashed one byte at a time in the order it is provided.
public protocol FNVHasher {
    /// The type of the `digest` property.
    associatedtype Digest
    
    /// The output of the hash function on every byte ingested so far.
    var digest: Digest { get }
    
    /// Initializes a new hasher.
    init()
    
    /// Hashes the provided ``FNVHashable`` value.
    ///
    /// - Parameter data: a value of a `FNVHashable` type to ingest
    mutating func combine<T>(_ data: T) where T : FNVHashable
    
    /// Hashes the provided `Sequence` of `UInt8` bytes.
    ///
    /// - Parameter data: a `Sequence` of `UInt8` values representing the data to ingest
    mutating func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8
}
