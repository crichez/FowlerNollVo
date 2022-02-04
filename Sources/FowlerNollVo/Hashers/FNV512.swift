//
//  FNV512.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

/// A 512-bit digest that behaves like an unsigned integer.
///
/// `DoubleWidth` is from the [Swift numerics](https://github.com/apple/swift-numerics)
/// open-source project. Expect all operations on a `Digest512` value to perform
/// noticeably worse than operations on `UInt64` and other standard library native integers.
public typealias Digest512 = DoubleWidth<Digest256>

extension Digest512 {
    fileprivate static var fnvPrime: Digest512 {
        Digest512(
            Digest256(
                Digest128(0x0000000000000000, 0x0000000000000000),
                Digest128(0x0000000001000000, 0x0000000000000000)
            ),
            Digest256(
                Digest128(0x0000000000000000, 0x0000000000000000),
                Digest128(0x0000000000000000, 0x0000000000000157)
            )
        )
    }
    
    fileprivate static var fnvOffset: Digest512 {
        Digest512(
            Digest256(
                Digest128(0xb86db0b1171f4416, 0xdca1e50f309990ac),
                Digest128(0xac87d059c9000000, 0x0000000000000d21)
            ),
            Digest256(
                Digest128(0xe948f68a34c192f6, 0x2ea79bc942dbe7ce),
                Digest128(0x182036415f56e34b, 0xac982aac4afe9fd9)
            )
        )
    }
}


/// A `FNV-1` hasher with a `Digest512` digest.
public struct FNV512: FNVHasher {
    public private(set) var digest: Digest512
    
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

/// A `FNV-1a` hasher with a `Digest512` digest.
public struct FNV512a: FNVHasher {
    public private(set) var digest: Digest512
    
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
