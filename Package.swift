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
            url: "https://s3-us-west-1.amazonaws.com/appodeal-ios/external-sdks/OMSDK_Appodeal/1.5.2/OMSDK_Appodeal.zip",
            checksum: "1a1a1c7ea5ae77ead964485e1e3e205de7efd13386c24e08a5fcae07d15e9a87"
        ) 
    ]
)
