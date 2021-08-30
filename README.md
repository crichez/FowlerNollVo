# FowlerNollVo

A FNV-1 implementation in Swift. This package has no dependencies. It hash been tested on all Apple platforms, and should run natively on all Swift platforms.

## Modules

FNV-1 is a simple non-cryptographic hash function. You can learn more about it [here](https://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function).

This package exposes 5 modules:
1. `FowlerNollVo`
2. `FNV32`
3. `FNV32a`
4. `FNV64`
5. `FNV64a`

### `FowlerNollVo`

The `FowlerNollVo` module is at the root of the dependency tree. It defines 2 protocols:
1. `FNVHashable`
2. `FNVHasher`

This module intends to closely mirror the Swift standard library `Hashable` implementation.
You can make your custom types conform to `FNVHashable` to hash them with a `FNVHasher`.

The code looks almost exactly the same:

```swift
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

To make a trivial type conform to `FNVHashable`, you only need to provide the hasher with a sequence of `UInt8` bytes:

```swift
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
// Initialize a hasher in a single call.
let hasher = FNV64a()
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
