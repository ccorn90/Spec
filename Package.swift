// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "Spec",
    dependencies: [
        .Package(url: "https://github.com/Quick/Nimble", majorVersion: 7)
    ]
)
