// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FowlerNollVo",
    products: [
        // The core library
        .library(
            name: "FowlerNollVo",
            targets: ["FowlerNollVo"]),
    ],
    targets: [
        // The target that defines the `FNVHashable` and `FNVHasher` protocols
        .target(
            name: "FowlerNollVo",
            dependencies: []),
        
        // 32-bit FNV implementations
        .target(
            name: "FNV32",
            dependencies: ["FowlerNollVo"]),
        .testTarget(
            name: "FNV32Tests",
            dependencies: ["FNV32"]),
        .target(
            name: "FNV32a",
            dependencies: ["FowlerNollVo"]),
        .testTarget(
            name: "FNV32aTests",
            dependencies: ["FNV32a"]),
        
        // 64-bit FNV implementations
        .target(
            name: "FNV64",
            dependencies: ["FowlerNollVo"]),
        .testTarget(
            name: "FNV64Tests",
            dependencies: ["FNV64"]),
        .target(
            name: "FNV64a",
            dependencies: ["FowlerNollVo"]),
        .testTarget(
            name: "FNV64aTests",
            dependencies: ["FNV64a"]),
    ]
)
