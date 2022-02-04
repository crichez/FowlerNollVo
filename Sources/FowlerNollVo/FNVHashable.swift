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
    /// The following example conforms a custom type by individually hashing each stored property:
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
    ///
    /// The following example conforms `Foundation.UUID`. Since `UUID` is a trivial type,
    /// the individual bytes of the value are fed to the hasher instead of the value itself.
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

#if swift(>=5.4) && !((os(macOS) || targetEnvironment(macCatalyst)) && arch(x86_64))
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
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

extension Optional: FNVHashable where Wrapped: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        switch self {
        case .some(let value):
            hasher.combine(value)
        case .none:
            // Pass an empty array to mutate the digest without data
            hasher.combine([])
        }
    }
}

extension Array: FNVHashable where Element: FNVHashable {
    public func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        forEach { element in
            hasher.combine(element)
        }
    }
}
