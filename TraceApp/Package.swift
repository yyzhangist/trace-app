// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Trace",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "Trace",
            targets: ["Trace"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Trace",
            dependencies: []),
        .testTarget(
            name: "TraceTests",
            dependencies: ["Trace"])
    ]
)
