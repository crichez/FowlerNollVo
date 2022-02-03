//
//  FNV256.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

extension DoubleWidth where Base == DoubleWidth<UInt64> {
    fileprivate static var fnvPrime: DoubleWidth<DoubleWidth<UInt64>> {
        DoubleWidth<DoubleWidth<UInt64>>(
            DoubleWidth<UInt64>(0x0000000000000000, 0x0000010000000000),
            DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000163)
        )
    }
    fileprivate static var fnvOffset: DoubleWidth<DoubleWidth<UInt64>> {
        DoubleWidth<DoubleWidth<UInt64>>(
            DoubleWidth<UInt64>(0xdd268dbcaac55036, 0x2d98c384c4e576cc),
            DoubleWidth<UInt64>(0xc8b1536847b6bbb3, 0x1023b4c8caee0535)
        )
    }
}

/// A `FNV-1` hasher with a `DoubleWidth<DoubleWidth<UInt64>>` digest.
public struct FNV256: FNVHasher {
    public private(set) var digest: DoubleWidth<DoubleWidth<UInt64>>
    
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
        digest = (digest &* .fnvPrime) ^ Digest(truncatingIfNeeded: firstByte)
        // Iterate over the rest of the bytes in the sequence
        while let byte = iterator.next() {
            digest = (digest &* .fnvPrime) ^ Digest(truncatingIfNeeded: byte)
        }
    }
}

/// A `FNV-1a` hasher with a `DoubleWidth<DoubleWidth<UInt64>>` digest.
public struct FNV256a: FNVHasher {
    public private(set) var digest: DoubleWidth<DoubleWidth<UInt64>>
    
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
        digest = (digest ^ Digest(truncatingIfNeeded: firstByte)) &* .fnvPrime
        // Iterate over the rest of the bytes in the sequence
        while let byte = iterator.next() {
            digest = (digest ^ Digest(truncatingIfNeeded: byte)) &* .fnvPrime
        }
    }
}
