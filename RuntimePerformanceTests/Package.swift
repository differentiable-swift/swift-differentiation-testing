// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RuntimePerformanceTests",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(url: "https://github.com/loonatick-src/package-benchmark", revision: "94f97d3c8e766869c641129f73bed83feb422ae5"),
        .package(url: "https://github.com/tayloraswift/swift-png", from: "4.4.0"),
    ],
    targets: [
        .executableTarget(
            name: "LanguageCoverage",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
            ],
            path: "Benchmarks/LanguageCoverage",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
        .executableTarget(
            name: "ShallowWaterPDE",
            dependencies: [
                .product(name: "Benchmark", package: "package-benchmark"),
                .product(name: "PNG", package: "swift-png"),
            ],
            path: "Benchmarks/ShallowWaterPDE",
            resources: [
                .copy("Resources/target.png"),
            ],
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark"),
            ]
        ),
    ]
)
