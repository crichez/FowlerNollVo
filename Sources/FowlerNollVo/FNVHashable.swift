//
//  FNVHashable.swift
//  FNVHashable
//
//  Created by Christopher Richez on 8/30/21.
//

/// A protocol that provides bytes for use with a Fowler-Noll-Vo ``FNVHasher``.
public protocol FNVHashable {
    /// The instructions on the content and sequence of data to feed to the hasher.
    ///
    /// You can implement this method in two ways, or a combination of both:
    /// 1. By calling ``hash(into:)``  on other ``FNVHashable`` values.
    /// 2. By providing a sequence of bytes to the ``FNVHasher.combine(_:)`` method.
    ///
    /// The following example makes a custom `struct` conform by individually hashing all of its properties:
    /// ```swift
    /// struct CustomType {
    ///     let id: Int
    ///     var name: String
    ///     var value: Double
    /// }
    ///
    /// extension CustomType: FNVHashable {
    ///     func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
    ///         hasher.combine(id)
    ///         hasher.combine(name)
    ///         hasher.combine(value)
    ///     }
    /// }
    /// ```
    /// - Note: You don't need to pass all properties to the hasher, only the ones you want to include to identify an instance.
    ///
    /// This next example enables conformance for a type provided by another framework: `Foundation.UUID`.
    /// ```swift
    /// import Foundation
    ///
    /// extension UUID: FNVHashable {
    ///     func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
    ///         withUnsafeBytes(of: self) { idBytes in
    ///             hasher.combine(idBytes)
    ///         }
    ///     }
    /// }
    /// ```
    /// The use of `withUnsafeBytes` may be intimidating, but it works here since `UUID` is a trivial type that simply stores 16 bytes.
    /// We can access its underlying memory as a sequence of bytes.
    /// In fact, this is how all built-in `Swift` ``BinaryInteger`` types conform to `FNVHashable`.
    ///
    /// Note this wouldn't work with `NSUUID`, since it is a reference type.
    /// As long as your method can provide a stable sequence of 8-bit unsigned integers ("bytes") to the hasher, it will be happy!
    func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher
}

extension Double: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

extension Float: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

#if arch(arm)
@available(macOS 11, *)
@available(macCatalyst 14, *)
@available(macOSApplicationExtension 11, *)
@available(macCatalystApplicationExtension 14, *)
@available(iOS 14, *)
@available(watchOS 7, *)
@available(tvOS 14, *)
extension Float16: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}
#endif

extension String: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        hasher.combine(utf8)
    }
}

extension Bool: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        hasher.combine(CollectionOfOne(self ? 1 : 0))
    }
}

extension UInt: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

extension UInt8: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        hasher.combine(CollectionOfOne(self))
    }
}

extension UInt16: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

extension UInt32: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

extension UInt64: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

extension Int: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

extension Int8: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

extension Int16: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

extension Int32: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}

extension Int64: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { hasher.combine($0) }
    }
}
