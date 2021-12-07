// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeviceStateMonitor",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "DeviceStateMonitor", targets: ["DeviceStateMonitor"]),
    ],
    targets: [
        .target(name: "DeviceStateMonitor", dependencies: []),
        .testTarget(name: "DeviceStateMonitorTests", dependencies: ["DeviceStateMonitor"]),
    ],
    swiftLanguageVersions: [.v5]
)
