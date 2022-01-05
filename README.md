# FowlerNollVo

A FNV-1 implementation in Swift. This package has no dependencies, and only uses the Swift standard library. 
The minimum swift-tools version to build this package is 5.0.

FNV-1 is a simple non-cryptographic hash function. 
You can learn more about it [here](https://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function).

## Platforms

This project is tested in continuous integration on the following platforms:
* Ubuntu 18.04
* Ubuntu 20.04
* Windows Server 2019
* macOS 11.5
* iOS 15.0
* tvOS 15.0
* watchOS 8.0

## Installation

`FowlerNollVo` is a [Swift Package Manager](https://github.com/apple/swift-package-manager) project.
To depend on it, include it in your `Package.swift` dependencies:

```swift
// Make sure you include the name parameter since the URL and package name are different
.package(
    name: "FowlerNollVo", 
    url: "https://github.com/crichez/swift-fowler-noll-vo",
    .upToNextMinor(from: "0.1.0")),
```

**All versions below 1.0.0 are considered pre-release.**
This means code-breaking changes may be added with a minor version bump.
To avoid this, use the `.upToNextMinor(from:)` version method in your package manifest, 
like in the example above. Once the project graduates to `1.0.0`, 
regular semantic versioning rules will apply.

## `FNVHashable`

This protocol intends to closely mirror the Swift standard library `Hashable` protocol.
You can make your custom types conform to `FNVHashable` to hash them with a `FNVHasher`.

The code looks almost exactly the same:

```swift
import FowlerNollVo

struct MyCustomType: FNVHashable {
    let id: Int
    var name: String
    var quality: Double
    
    func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(quality)
    }
}
```

To make a trivial type conform to `FNVHashable`, 
you only need to provide the hasher with a sequence of `UInt8` bytes:

```swift
import FowlerNollVo
import Foundation

extension UUID: FNVHashable {
    func hash<Hasher>(into hasher: inout Hasher) where Hasher : FNVHasher {
        withUnsafeBytes(of: self) { idBytes in 
            hasher.combine(idBytes)
        }
    }
}
```

## Hashers

The following hasher types are built-in:
* `FNV1Hasher`
* `FNV1aHasher`

The old `FNV1Hasher` is considered deprecated by the creators, but is included anyway.
These types are generic over a `FNVDigest`.

### Usage

```swift
import FowlerNollVo

// Initialize a hasher in a single call
var hasher = FNV1aHasher<UInt64>()
// Hash any FNVHashable value
hasher.combine(12)
hasher.combine("this is a string!")
hasher.combine(MyCustomType())
// Retrieve the digest as an unsigned integer for easy calculations
let digest: UInt64 = hasher.digest
```

### `FNVDigest`

All digests must conform to the `FNVDigest` protocol. This protocol requires only the basic
values and operations necessary to work with the built-in hash functions.

The following code is the actual protocol definition, and the implementation for `UInt32`.

```swift
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
```
