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
* iOS 14.5
* tvOS 14.5
* watchOS 7.4

All pull requests to the `main` branch will automatically be tested on all supported platforms.
All tests must pass to committed to the main branch.

## Installation

`FowlerNollVo` is [Swift Package Manager](https://github.com/apple/swift-package-manager) project.
To depend on it, include it in your `Package.swift` dependencies:

```swift
// Make sure you include the name parameter since the URL and package name are different
.package(
    name: "FowlerNollVo", 
    url: "https://github.com/crichez/swift-fowler-noll-vo",
    .upToNextMinor(from: "0.0.1")),
```

**All versions below 1.0.0 are considered pre-release.**
This means code-breaking changes may be added with a minor version bump.
To avoid this, use the `.upToNextMinor(from:)` version method in your package manifest, 
like in the example above. Once the project graduates to `1.0.0`, 
regular semantic versioning rules will apply.

## Modules

This package exposes 5 modules:
* `FowlerNollVo`
* `FNV32`
* `FNV32a`
* `FNV64`
* `FNV64a`

### `FowlerNollVo`

The `FowlerNollVo` module is at the root of the dependency tree. It defines 2 protocols:
* `FNVHashable`
* `FNVHasher`

This module intends to closely mirror the Swift standard library `Hashable` implementation.
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

You can learn more about how to conform to these protocols by reading inline documentation.

### Other Modules

The other modules are actual implementations of FNV-1 & FNV-1a with 32 & 64 bit digests.

```swift
import FowlerNollVo
import FNV64a

// Initialize a hasher in a single call
var hasher = FNV64a()
// Hash any FNVHashable value
hasher.combine(12)
hasher.combine("this is a string!")
hasher.combine(MyCustomType())
// Retrieve the digest as an unsigned integer for easy calculations
let digest: UInt64 = hasher.digest
```

Although only four functions are provided, you may implement others using a different digest size. 
Currently, the `FNVHasher` protocol requires the `Digest` to conform to `UnsignedInteger`.
This restriction is there for calculation simplicity, but feel free to experiment and pull request!
