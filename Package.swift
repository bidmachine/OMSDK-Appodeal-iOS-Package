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
            targets: ["OMSDK_AppodealWrapper"]
        )
    ],
    targets: [
        .target(
            name: "OMSDK_AppodealWrapper",
            dependencies: ["OMSDK_AppodealBinary"],
            path: "Sources/OMSDK_AppodealWrapper",
            resources: [
                .copy("Resources/omsdk_appodeal_service.plist"),
                .copy("Resources/PrivacyInfo.xcprivacy")
            ]
        ),
        .binaryTarget(
            name: "OMSDK_AppodealBinary",
            url: "https://bidmachine-ios.s3.amazonaws.com/OMSDK_Appodeal/1.6.3.0/package/OMSDK_Appodeal.xcframework.zip",
            checksum: "placeholder"
        )
    ]
)
