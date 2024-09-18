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
            url: "https://s3-us-west-1.amazonaws.com/appodeal-ios/external-sdks/OMSDK_Appodeal/1.5.1/OMSDK_Appodeal.zip",
            checksum: "23ef35638a7da8a370f909a336d7a17f282925e2092e085eae96d17a242cbcfc"
        ) 
    ]
)
