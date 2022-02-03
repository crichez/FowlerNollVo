# FowlerNollVo

A FNV-1 implementation in Swift. This package has no dependencies. 
The minimum swift-tools version to build this package is 5.0.

FNV-1 is a simple non-cryptographic hash function. 
You can learn more about it [here](https://en.wikipedia.org/wiki/Fowler–Noll–Vo_hash_function).

## Platforms

This project is tested in continuous integration on the following platforms:
* Ubuntu 20.04 LTS
* Windows Server 2019
* macOS 11.5
* iOS 15.2
* tvOS 15.2
* watchOS 8.3

## Installation

`FowlerNollVo` is a [Swift Package Manager](https://github.com/apple/swift-package-manager) project.
To depend on it, include it in your `Package.swift` dependencies:

```swift
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

## Hashers

The following hasher types are built-in:
* `FNV32` & `FNV32a`
* `FNV64` & `FNV64a`
* `FNV128` & `FNV128a`
* `FNV256` & `FNV256a`
* `FNV512` & `FNV512a`
* `FNV1024` & `FNV1024a`

**Note:** `FNV128` and hashers with larger digests all use `DoubleWidth` 
from [the swift numerics project](https://github.com/apple/swift-numerics).
That code was included in this project under its original Apache 2.0 license,
and is still considered experimental.

Although performance from 32 to 64-bit digests is similar, 
performance quickly degrades with larger digests. Getting a 1024-bit digest
from 64 bits of input data takes around 0.33 seconds on a M1 MacBook Pro.

### Usage

```swift
import FowlerNollVo

var hasher = FNV64a()

hasher.combine(12)
hasher.combine("this is a string!")
hasher.combine(MyCustomType())

let digest: UInt64 = hasher.digest
```
