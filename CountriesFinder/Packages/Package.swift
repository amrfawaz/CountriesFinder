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
            name: "CoreInterface",
            targets: ["CoreInterface"]),
        .library(
            name: "NetworkManager",
            targets: ["NetworkManager"]),
        .library(
            name: "Home",
            targets: ["Home"]
        ),
        .library(
            name: "CountryDetails",
            targets: ["CountryDetails"]
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
            name: "CoreInterface",
            path: "CoreInterface/Sources"
        ),
        .target(
            name: "NetworkManager",
            path: "NetworkManager/Sources"
        ),
        .target(
            name: "Home",
            dependencies: [
                "NetworkManager",
                "SharedModels",
                "CountryDetails"
            ],
            path: "Home/Sources"
        ),
        .target(
            name: "CountryDetails",
            dependencies: [
                "SharedModels",
                "CoreInterface"
            ],
            path: "CountryDetails/Sources"
        ),
        .target(
            name: "SharedModels",
            dependencies: [],
            path: "SharedModels/Sources"
        ),
        .testTarget(
            name: "CountryDetailsTests",
            dependencies: ["CountryDetails"],
            path: "CountryDetails/Tests"
        ),
    ]
)
