//
//  FNV128.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

extension DoubleWidth where Base == UInt64 {
    fileprivate static var fnvPrime: DoubleWidth<UInt64> {
        DoubleWidth<UInt64>(0x0000000001000000, 0x000000000000013B)
    }
    
    fileprivate static var fnvOffset: DoubleWidth<UInt64> {
        DoubleWidth<UInt64>(0x6c62272e07bb0142, 0x62b821756295c58d)
    }
}

/// A `FNV-1` hasher with a `DoubleWidth<UInt64>` digest.
public struct FNV128: FNVHasher {
    public private(set) var digest: DoubleWidth<UInt64>
    
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

/// A `FNV-1a` hasher with a `DoubleWidth<UInt64>` digest.
public struct FNV128a: FNVHasher {
    public private(set) var digest: DoubleWidth<UInt64>
    
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
