//
//  FNV1024.swift
//  
//
//  Created by Christopher Richez on 2/2/22.
//

extension DoubleWidth where Base == DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>> {
    fileprivate static var fnvPrime: DoubleWidth<DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>> {
        DoubleWidth<DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>>(
            DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>(
                DoubleWidth<DoubleWidth<UInt64>>(
                    DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000),
                    DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000)
                ),
                DoubleWidth<DoubleWidth<UInt64>>(
                    DoubleWidth<UInt64>(0x0000000000000000, 0x0000010000000000),
                    DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000)
                )
            ),
            DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>(
                DoubleWidth<DoubleWidth<UInt64>>(
                    DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000),
                    DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000)
                ),
                DoubleWidth<DoubleWidth<UInt64>>(
                    DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000),
                    DoubleWidth<UInt64>(0x0000000000000000, 0x000000000000018D)
                )
            )
        )
    }
    
    fileprivate static var fnvOffset: DoubleWidth<DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>> {
        DoubleWidth<DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>>(
            DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>(
                DoubleWidth<DoubleWidth<UInt64>>(
                    DoubleWidth<UInt64>(0x0000000000000000, 0x005f7a76758ecc4d),
                    DoubleWidth<UInt64>(0x32e56d5a591028b7, 0x4b29fc4223fdada1)
                ),
                DoubleWidth<DoubleWidth<UInt64>>(
                    DoubleWidth<UInt64>(0x6c3bf34eda3674da, 0x9a21d90000000000),
                    DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000)
                )
            ),
            DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>(
                DoubleWidth<DoubleWidth<UInt64>>(
                    DoubleWidth<UInt64>(0x0000000000000000, 0x0000000000000000),
                    DoubleWidth<UInt64>(0x0000000000000000, 0x000000000004c6d7)
                ),
                DoubleWidth<DoubleWidth<UInt64>>(
                    DoubleWidth<UInt64>(0xeb6e73802734510a, 0x555f256cc005ae55),
                    DoubleWidth<UInt64>(0x6bde8cc9c6a93b21, 0xaff4b16c71ee90b3)
                )
            )
        )
    }
}


/// A `FNV-1` hasher with a `DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>` digest.
public struct FNV1024: FNVHasher {
    public private(set) var digest: DoubleWidth<DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>>
    
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
public struct FNV1024a: FNVHasher {
    public private(set) var digest: DoubleWidth<DoubleWidth<DoubleWidth<DoubleWidth<UInt64>>>>
    
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
