// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorPluginIRoot",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapacitorPluginIRoot",
            targets: ["IRootPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "IRootPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/IRootPlugin"),
        .testTarget(
            name: "IRootPluginTests",
            dependencies: ["IRootPlugin"],
            path: "ios/Tests/IRootPluginTests")
    ]
)