// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OMSDK_Appodeal",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "OMSDK_Appodeal",
            targets: ["OMSDK_Appodeal"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "OMSDK_Appodeal",
            url: "https://s3-us-west-1.amazonaws.com/appodeal-ios/external-sdks/OMSDK_Appodeal/1.6.0/SPM/OMSDK_Appodeal.zip",
            checksum: "ee366dd03c3a4b3bbee7afa443e7539951c1e8c213403048ba008f02f0fb0eb6"
        )
    ]
)
