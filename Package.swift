// swift-tools-version: 6.2





import PackageDescription

let package = Package(
    name: "Sprogal",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(name: "Sprogal", targets: ["Sprogal"]),
    ],
    targets: [
        .target(name: "Sprogal"),
    ]
)
