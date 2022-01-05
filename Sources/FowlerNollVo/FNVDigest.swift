//
//  FNVDigest.swift
//  
//
//  Created by Christopher Richez on 1/5/22.
//

/// A type that can be used as a digest by the Fowler-Noll-Vo hash function.
public protocol FNVDigest {
    /// The `fnv_prime` value for this digest size.
    static var fnvPrime: Self { get }
    
    /// The `offset_basis` value for this digest size.
    static var fnvOffset: Self { get }
    
    /// An operator that performs a bitwise `XOR` between this digest and an individual byte.
    static func ^ (lhs: Self, rhs: UInt8) -> Self
    
    /// An operator that performs an unchecked multiplication on two digests.
    static func &* (lhs: Self, rhs: Self) -> Self
}

extension UInt32: FNVDigest {
    public static var fnvPrime: UInt32 { 16777619 }
    public static var fnvOffset: UInt32 { 2166136261 }
    
    public static func ^ (lhs: UInt32, rhs: UInt8) -> UInt32 {
        lhs ^ UInt32(truncatingIfNeeded: rhs)
    }
}

extension UInt64: FNVDigest {
    public static var fnvPrime: UInt64 { 1099511628211 }
    public static var fnvOffset: UInt64 { 14695981039346656037 }
    
    public static func ^ (lhs: UInt64, rhs: UInt8) -> UInt64 {
        lhs ^ UInt64(truncatingIfNeeded: rhs)
    }
}
