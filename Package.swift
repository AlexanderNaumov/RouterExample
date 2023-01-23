// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Router",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Router", targets: ["Router"]),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.1.4")
    ],
    targets: [
        .target(name: "Router", dependencies: [.product(name: "Introspect", package: "SwiftUI-Introspect")], path: "Sources")
    ]
)
