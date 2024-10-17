// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "DeeplinkRouter",
    platforms: [
        .iOS(.v13) // Зависимость от iOS
    ],
    products: [
        .library(
            name: "DeeplinkRouter",
            targets: ["DeeplinkRouter"]),
    ],
    targets: [
        .target(
            name: "DeeplinkRouter",
            dependencies: []),
        .testTarget(
            name: "DeeplinkRouterTests",
            dependencies: ["DeeplinkRouter"]),
    ]
)
