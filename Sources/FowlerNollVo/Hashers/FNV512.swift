//
//  FNV512.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

extension DoubleWidth where Base == DoubleWidth<DoubleWidth<UInt64>> {
    fileprivate static var fnvPrime: DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>> {
        DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>(
            DoubleWidth<DoubleWidth<UInt64>>(
                DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000),
                DoubleWidth<UInt64>(0x0000000001000000, 0x0000000000000000)
            ),
            DoubleWidth<DoubleWidth<UInt64>>(
                DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000),
                DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000157)
            )
        )
    }
    
    fileprivate static var fnvOffset: DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>> {
        DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>(
            DoubleWidth<DoubleWidth<UInt64>>(
                DoubleWidth<UInt64>(0xb86db0b1171f4416, 0xdca1e50f309990ac),
                DoubleWidth<UInt64>(0xac87d059c9000000, 0x0000000000000d21)
            ),
            DoubleWidth<DoubleWidth<UInt64>>(
                DoubleWidth<UInt64>(0xe948f68a34c192f6, 0x2ea79bc942dbe7ce),
                DoubleWidth<UInt64>(0x182036415f56e34b, 0xac982aac4afe9fd9)
            )
        )
    }
}


/// A `FNV-1` hasher with a `DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>` digest.
public struct FNV512: FNVHasher {
    public private(set) var digest: DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>
    
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

/// A `FNV-1a` hasher with a `DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>` digest.
public struct FNV512a: FNVHasher {
    public private(set) var digest: DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>
    
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
