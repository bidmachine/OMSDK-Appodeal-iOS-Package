// swift-tools-version:5.7

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
            url: "https://bidmachine-ios.s3.amazonaws.com/OMSDK_Appodeal/1.6.3/package/OMSDK_Appodeal.xcframework.zip",
            checksum: "3e3f791957a55085954608740455c6abad2d1f4381e5a4263242289030f7976f"
        )
    ]
)
