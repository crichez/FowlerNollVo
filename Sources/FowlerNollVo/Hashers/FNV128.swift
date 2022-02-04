//
//  FNV128.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

/// A 128-bit digest that behaves like an unsigned integer.
///
/// `DoubleWidth` is from the [Swift numerics](https://github.com/apple/swift-numerics)
/// open-source project. Expect all operations on a `Digest128` value to perform slighly worse
/// than operations on `UInt64` and other standard library native integers.
public typealias Digest128 = DoubleWidth<UInt64>

extension Digest128 {
    fileprivate static var fnvPrime: Digest128 {
        Digest128(0x0000000001000000, 0x000000000000013B)
    }
    
    fileprivate static var fnvOffset: Digest128 {
        Digest128(0x6c62272e07bb0142, 0x62b821756295c58d)
    }
}

/// A `FNV-1` hasher with a `Digest128` digest.
public struct FNV128: FNVHasher {
    public private(set) var digest: Digest128
    
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

/// A `FNV-1a` hasher with a `Digest128` digest.
public struct FNV128a: FNVHasher {
    public private(set) var digest: Digest128
    
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
