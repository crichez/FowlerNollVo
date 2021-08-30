//
//  FNVHasher.swift
//  FNVHasher
//
//  Created by Christopher Richez on August 30th 2021
//

/// A type that implements a Fowler-Noll-Vo hash function.
///
/// You need to specify:
/// 1. The ``Digest`` type.
/// 2. The associated ``prime`` and ``offset`` properties for your digest type.
/// 3. The byte-level ``combine(_:)-4hjsf`` method.
///
/// If your ``Digest`` is ``UInt32`` or ``UInt64``, these are provided for you and you only need to define the ``digest-swift.property`` property. Otherwise, you can probably find these on [Wikipedia](https://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function).
///
/// From there, you have everything you need to write the byte-level ``combine(_:)-4hjsf`` method.
/// A default implementation is always provided for the instance-level ``combine(_:)-477ty`` method.
///
/// A working hasher can be created by:
///
/// Declaring storage for the digest, using the desired ``UnsignedInteger`` type:
/// ```swift
/// /// A Fowler-Noll-Vo hasher with a 32-bit digest.
/// struct FNV32a: FNVHasher {
///     var digest: UInt32
/// }
/// ```
/// Assigning the `prime` and `offset` values:
/// ```swift
/// extension FNV32a {
///     static var prime: { 16777619 }
///     static var offset: { 2166136261 }
/// }
/// ```
/// Writing the byte-level ``combine(_:)-4hjsf`` method:
/// ```swift
/// extension FNV32a {
///     /// A method that hashes a sequence of bytes using the FNV-1a hash function.
///     func hash<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8 {
///         for byte in data {
///             digest = (digest ^ UInt32(truncatingIfNeeded: byte)) &* Self.prime
///         }
///     }
/// }
/// ```
///
/// The swift standard library does not provide any ``UnsignedInteger`` types more than 64 bits wide.
/// Custom implementations are available on Github, or you can create your own.
/// Make sure whichever you use implements an overflow-safe multiplication operator, or you may trigger errors.
public protocol FNVHasher {
    /// The unisgned integer type to use as a digest.
    ///
    /// The swift standard library does not provide any ``UnsignedInteger`` types more than 64 bits wide.
    /// Custom implementations are available on Github, or you can create your own.
    associatedtype Digest: UnsignedInteger
    
    /// The current digest of the hash function.
    ///
    /// To conform to `FNVHasher` you must declare storage for your `Digest` type as follows:
    /// ```swift
    /// struct FNV32a: FNVHasher {
    ///     var digest: UInt32
    /// }
    /// ```
    ///
    /// - Warning: This property should not be mutated outside the hasher itself.
    var digest: Digest { get set }
    
    /// The `FNV_prime` value for the associated digest size.
    ///
    /// If ``Digest`` is ``UInt32`` or ``UInt64``, this value is provided for you.
    /// Otherwise, you can find `FNV_prime` values for a given digest size on [Wikipedia](https://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function).
    /// ```swift
    /// struct FNV32a: FNVHasher {
    ///     var digest: UInt32
    ///     static var prime: UInt32 { 16777619 }
    ///     static var offset: UInt32 { 2166136261 }
    /// }
    /// ```
    static var prime: Digest { get }
    
    /// The `offset_basis` value for the associated digest size.
    ///
    /// The appropriate value is provided where ``Digest`` is ``UInt32`` or ``UInt64``.
    /// Otherwise, you can find `offset_basis` values for other digest sizes on [Wikipedia](https://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function).
    /// ```swift
    /// struct FNV32a: FNVHasher {
    ///     var digest: UInt32
    ///     static var prime: UInt32 { 16777619 }
    ///     static var offset: UInt32 { 2166136261 }
    /// }
    /// ```
    static var offset: Digest { get }
    
    /// Hashes the provided sequence of bytes.
    ///
    /// A default implementation is provided where ``Digest`` is `UInt32` or `UInt64`.
    /// This default implementation uses the `FNV-1a` hash function.
    ///
    /// To use the old `FNV-1` function, you can override the default implementation by declaring your own ``combine(_:)-8ngc`` method as follows, and multiplying before XOR-ing:
    /// ```swift
    /// struct FNV32: FNVHasher {
    ///     var digest: UInt32
    ///
    ///     /// This method uses the old `FNV-1` hash function.
    ///     func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8 {
    ///         for byte in data {
    ///             /// Multiply first, then XOR
    ///             digest = (digest * Self.prime) ^ UInt32(truncatingIfNeeded: byte)
    ///         }
    ///     }
    /// }
    /// ```
    mutating func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8
    
    /// Hashes the provided ``FNVHashable`` elements.
    ///
    /// A default implementation is always provided.
    mutating func combine<T>(_ data: T) where T : FNVHashable
}

extension FNVHasher {
    /// Hashes the provided ``FNVHashable`` elements.
    public mutating func combine<T>(_ data: T) where T : FNVHashable {
        data.hash(into: &self)
    }
}

extension FNVHasher where Digest == UInt32 {
    public static var prime: UInt32 { 16777619 }
    public static var offset: UInt32 { 2166136261 }
    public mutating func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8 {
        for byte in data {
            digest = (digest ^ Digest(truncatingIfNeeded: byte)) &* Self.prime
        }
    }
}

extension FNVHasher where Digest == UInt64 {
    public static var prime: UInt64 { 1099511628211 }
    public static var offset: UInt64 { 14695981039346656037 }
    public mutating func combine<Data>(_ data: Data) where Data : Sequence, Data.Element == UInt8 {
        for byte in data {
            digest = (digest ^ Digest(truncatingIfNeeded: byte)) &* Self.prime
        }
    }
}
