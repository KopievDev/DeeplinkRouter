// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "DeeplinkRouter",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "DeeplinkRouter",
            targets: ["DeeplinkRouter"]),
    ],
    targets: [
        .target(
            name: "DeeplinkRouter",
            dependencies: [],
            path: "Sources",
            exclude: [],
            resources: [],
            swiftSettings: [],
            linkerSettings: [
                .linkedFramework("UIKit")
            ]
        ),
        .testTarget(
            name: "DeeplinkRouterTests",
            dependencies: ["DeeplinkRouter"],
            path: "Tests"
        ),
    ]
)
