// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name:"OMSDK_Appodeal",
    platforms: [
        .iOS("10.0")
    ],
    products: [
        .library(
            name: "OMSDK_Appodeal",
            type: .dynamic,
            targets: [
                "OMSDK_AppodealWrapper"
            ]
        )
    ],
    targets: [
        .target(
            name: "OMSDK_AppodealWrapper",
            dependencies: [
                .target(name: "OMSDK_Appodeal")
            ],
            path: "Wrapper"
        ),
        .binaryTarget(
            name: "OMSDK_Appodeal",
            url: "https://s3-us-west-1.amazonaws.com/appodeal-ios/external-sdks/OMSDK_Appodeal/1.4.12/OMSDK_Appodeal.zip",
            checksum: "d7c38b070ba082723ea2e5f71a86b195aa8c93c09d8b1027787976964c3746ac"
        )
    ]
)
