// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "RichTextView",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "RichTextView", targets: ["RichTextView"])
    ],
    dependencies: [
        .package(name: "Down", url: "https://github.com/johnxnguyen/Down", .upToNextMajor(from: "0.11.0")),
        .package(name: "SnapKit", url: "https://github.com/SnapKit/SnapKit", .upToNextMajor(from: "5.0.1")),
        .package(name: "iosMath", url: "https://github.com/tophatmonocle/iosMath", .upToNextMajor(from: "1.1.1")),
        .package(name: "SwiftRichString", url: "https://github.com/tophatmonocle/SwiftRichString", .branch("master"))
    ],
    targets: [
        .target(
            name: "RichTextView",
            dependencies: [
                .product(name: "Down", package: "Down"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "iosMath", package: "iosMath"),
                .product(name: "SwiftRichString", package: "SwiftRichString"),
            ],
            path: "Source",
            exclude: ["Info.plist"]
        ),
    ]
)
