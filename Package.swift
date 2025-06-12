// swift-tools-version:5.3

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
                "OMSDK_AppodealLib"
            ]
        )
    ],
    targets: [
        target(
            name: "OMSDK_AppodealLib",
            dependencies: ["OMSDK_Appodeal"],
            path: "Sources"
        ),
        .binaryTarget(
            name: "OMSDK_Appodeal",
            url: "https://s3-us-west-1.amazonaws.com/appodeal-ios/external-sdks/OMSDK_Appodeal/1.5.5/OMSDK_Appodeal.zip",
            checksum: "e94cd38f6da7f5f23bdee49dd8963881a40ba91307041581f7bfc1ca389687aa"
        )
    ]
)
