// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PagoUIKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PagoUIKit",
            targets: [
                "PagoUIKit",
            ]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package.
        // A target can define a module or a test suite.
        //
        // Targets can depend on other targets in this package,
        // and on products in packages which this package depends on.
        .target(
            name: "PagoUIKit",
            dependencies: [
            ],
            path: "Sources/PagoUIKit/",
            exclude: [
                "Resources/README.txt",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
        .testTarget(
            name: "PagoUIKitTests",
            dependencies: [
                "PagoUIKit",
            ],
            path: "Tests/PagoUIKit/",
            exclude: [
                "Resources/README.md",
                "Toolbox/README.md",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)
