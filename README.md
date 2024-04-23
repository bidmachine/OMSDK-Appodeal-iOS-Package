# OMSDK-Appodeal

[![Version](https://img.shields.io/cocoapods/v/OMSDK_Appodeal.svg?style=flat)](http://cocoapods.org/pods/OMSDK_Appodeal)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SPM Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)

# Table Of Contents

- [OMSDK-Appodeal](#omsdk-appodeal)
- [Table Of Contents](#table-of-contents)
- [Cocoapods](#cocoapods)
- [Swift Package Manager](#swift-package-manager)
- [Carthage](#carthage)

# [Cocoapods](#pods)

In order to install `OMSDK_Appodeal` framework via Cocoapods, you should choose the binary version, that you require, add it to your `Podfile` and run `pod install/update`:

```ruby
pod 'OMSDK_Appodeal'
```

For more reference on using Cocoapods, please click [here](https://guides.cocoapods.org/)

# [Swift Package Manager](#SPM)

1. **Add a Swift Package File**
   - In your Xcode project, go to **File** > **Swift Packages** > **Add Package Dependency**.

3. **Enter Package Repository URL**
   - In the dialog that appears, enter the URL of the repository that hosts the OMSDK_Appodeal package:
  
   ```ruby
    https://github.com/bidmachine/OMSDK-Appodeal-SPM
    ```

4. **Select fetched package**
5. **Click on the **Next** button to proceed and choose the target, which should be using the dependency**
6. **Integrate Package**


# [Carthage](#carthage)

In order to fetch **OMSDK_Appodeal** artifacts using `Carthage`, please use binary-only method, described [here](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile). 
All necessary JSON files with links to the binary artifacts are located in `Carthage` folder in the root of the repository.

1. **Update Cartfile**
   - Add binary dependency
  
    ```ruby
    binary "https://raw.githubusercontent.com/bidmachine/OMSDK-Appodeal-SPM/main/Carthage/omsdk-appodeal-ios.json"
    ``` 

2. **Run** `carthage update --use-xcframeworks`

3. **Drag `OMSDK_Appodeal.xcframework` from Carthage/Build into the "Frameworks and Libraries" section of your application’s Xcode project**.

4. **If you are using Carthage for an application, select "Embed & Sign", otherwise "Do Not Embed".**


