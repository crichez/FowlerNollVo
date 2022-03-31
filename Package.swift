// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FowlerNollVo",
    products: [
        .library(
            name: "FowlerNollVo",
            targets: ["FowlerNollVo"]),
    ],
    dependencies: [
        //.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "FowlerNollVo",
            dependencies: []),
        .testTarget(
            name: "FowlerNollVoTests",
            dependencies: ["FowlerNollVo"])
    ]
)
