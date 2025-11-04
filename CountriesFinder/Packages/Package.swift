// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Packages",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Packages",
            targets: ["Packages"]),
        .library(
            name: "NetworkManager",
            targets: ["NetworkManager"]),
        .library(
            name: "Home",
            targets: ["Home"]
        ),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]),
            
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Packages"),

        .target(
            name: "NetworkManager",
            path: "NetworkManager/Sources"
        ),
        .target(
            name: "Home",
            dependencies: [
                "NetworkManager",
                "SharedModels"
            ],
            path: "Home/Sources"
        ),
        .target(
            name: "SharedModels",
            dependencies: [],
            path: "SharedModels/Sources"
        ),
        .testTarget(
            name: "PackagesTests",
            dependencies: ["Packages"]
        ),
    ]
)
