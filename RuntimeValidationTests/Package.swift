// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ValidationTests",
    products: [],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-gen.git", from: "0.4.0"),
        .package(url: "https://github.com/apple/swift-numerics.git", from: "1.0.2"),
    ],
    targets: [
        .target(
            name: "ValidationTesting",
            dependencies: [
                .product(name: "Numerics", package: "swift-numerics"),
            ]
        ),
        .testTarget(
            name: "ValidationTestingTests",
            dependencies: ["ValidationTesting"]
        ),
        .testTarget(
            name: "ValidationTests",
            dependencies: [
                "ValidationTesting",
                .product(name: "Gen", package: "swift-gen"),
            ]
        ),
    ]
)
