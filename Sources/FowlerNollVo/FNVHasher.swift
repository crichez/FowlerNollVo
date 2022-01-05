//
//  FNVHasher.swift
//  
//
//  Created by Christopher Richez on 1/5/22.
//

/// A protocl that defines the API requirements for a FNV hasher.
public protocol FNVHasher {
    /// Hashes the provided ``FNVHashable`` elements.
    mutating func combine<T>(_ data: T) where T : FNVHashable
    
    /// Feeds the provided data to the hasher.
    mutating func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8
}
