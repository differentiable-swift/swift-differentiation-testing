// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "70000",
    dependencies: [.package(url: "https://github.com/apple/swift-collections.git", from: "1.0.0")],
    targets: [
        .executableTarget(
            name: "70000",
            dependencies: [.product(name: "Collections", package: "swift-collections")])
    ]
)
