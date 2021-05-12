// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Asana",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Asana",
            targets: ["Asana"]
        ),
        .library(
            name: "Yoga",
            targets: ["SwiftYoga"]
        ),
    ],
    targets: [
        .target(
            name: "Asana",
            dependencies: ["SwiftYoga"],
            exclude: ["LICENSE"]
        ),
        .target(
            name: "SwiftYoga",
            dependencies: ["CYoga"],
            exclude: ["LICENSE"]
        ),
        .target(
            name: "CYoga",
            exclude: ["LICENSE"],
            publicHeadersPath: "public",
            cSettings: [.headerSearchPath("./")]
        ),
        .testTarget(
            name: "AsanaTests",
            dependencies: ["Asana"]
        ),
    ],
    cLanguageStandard: .gnu11,
    cxxLanguageStandard: .gnucxx14
)
