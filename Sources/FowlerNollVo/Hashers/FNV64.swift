//
//  FNV64.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

extension UInt64 {
    fileprivate static var fnvPrime: UInt64 { 1099511628211 }
    fileprivate static var fnvOffset: UInt64 { 14695981039346656037 }
}

/// A `FNV-1` hasher with a `UInt64` digest.
public struct FNV64: FNVHasher {
    public private(set) var digest: UInt64
    
    public init() {
        self.digest = .fnvOffset
    }
    
    public mutating func combine<T>(_ data: T) where T : FNVHashable {
        data.hash(into: &self)
    }
    
    public mutating func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8 {
        // Get an iterator for the data sequence
        var iterator = data.makeIterator()
        // Get the first byte of the sequence
        guard let firstByte = iterator.next() else {
            // If the sequence is empty, multiply by fnv_prime
            digest = digest &* .fnvPrime
            return
        }
        // Combine the first byte manually
        digest = (digest &* .fnvPrime) ^ UInt64(truncatingIfNeeded: firstByte)
        // Iterate over the rest of the bytes in the sequence
        while let byte = iterator.next() {
            digest = (digest &* .fnvPrime) ^ UInt64(truncatingIfNeeded: byte)
        }
    }
}

/// A `FNV-1a` hasher with a `UInt64` digest.
public struct FNV64a: FNVHasher {
    public private(set) var digest: UInt64
    
    public init() {
        self.digest = .fnvOffset
    }
    
    public mutating func combine<T>(_ data: T) where T : FNVHashable {
        data.hash(into: &self)
    }
    
    public mutating func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8 {
        // Get an iterator for the data sequence
        var iterator = data.makeIterator()
        // Get the first byte of the sequence
        guard let firstByte = iterator.next() else {
            // If the sequence is empty, multiply by fnv_prime
            digest = digest &* .fnvPrime
            return
        }
        // Combine the first byte manually
        digest = (digest ^ UInt64(truncatingIfNeeded: firstByte)) &* .fnvPrime
        // Iterate over the rest of the bytes in the sequence
        while let byte = iterator.next() {
            digest = (digest ^ UInt64(truncatingIfNeeded: byte)) &* .fnvPrime
        }
    }
}
