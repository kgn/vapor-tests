import PackageDescription

let package = Package(
    name: "notEqualsNull",
    targets: [
        Target(name: "App", dependencies: ["AppLogic"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1, minor: 5),
        .Package(url: "https://github.com/sfaxon/vapor-memory-provider.git", majorVersion: 1)
    ]
)

