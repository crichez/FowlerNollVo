//
//  FNV256.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

/// A 256-bit digest that behaves like an unsigned integer.
///
/// `DoubleWidth` is from the [Swift numerics](https://github.com/apple/swift-numerics)
/// open-source project. Expect all operations on a `Digest256` value to perform slighly worse
/// than operations on `UInt64` and other standard library native integers.
public typealias Digest256 = DoubleWidth<Digest128>

extension Digest256 {
    fileprivate static var fnvPrime: Digest256 {
        Digest256(
            Digest128(0x0000000000000000, 0x0000010000000000),
            Digest128(0x0000000000000000, 0x0000000000000163)
        )
    }
    
    fileprivate static var fnvOffset: Digest256 {
        Digest256(
            Digest128(0xdd268dbcaac55036, 0x2d98c384c4e576cc),
            Digest128(0xc8b1536847b6bbb3, 0x1023b4c8caee0535)
        )
    }
}

/// A `FNV-1` hasher with a `Digest256` digest.
public struct FNV256: FNVHasher {
    public private(set) var digest: Digest256
    
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

/// A `FNV-1a` hasher with a `Digest256` digest.
public struct FNV256a: FNVHasher {
    public private(set) var digest: Digest256
    
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
