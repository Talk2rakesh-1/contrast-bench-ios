// swift-tools-version: 6.0
import PackageDescription

let package = Package(
  name: "ContrastCore", platforms: [.macOS(.v13)],
  products: [.library(name: "ContrastCore", targets: ["ContrastCore"])],
  targets: [
    .target(name: "ContrastCore"),
    .testTarget(name: "ContrastCoreTests", dependencies: ["ContrastCore"]),
  ])
