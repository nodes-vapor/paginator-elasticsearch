// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "PaginatorElasticsearch",
    products: [
        .library(
            name: "PaginatorElasticsearch",
            targets: ["PaginatorElasticsearch"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ryangrimm/VaporElasticsearch.git", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/nodes-vapor/paginator.git", from: "3.0.0-beta")
    ],
    targets: [
        .target(
            name: "PaginatorElasticsearch",
            dependencies: [
                "Elasticsearch",
                "Paginator"
            ],
            path: "Sources"),
        .testTarget(
            name: "PaginatorElasticsearchTests",
            dependencies: ["PaginatorElasticsearch"],
            path: "Tests"),
    ]
)
