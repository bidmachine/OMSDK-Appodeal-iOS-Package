set -e

# Repackage OMSDK Static XCFramework into proper framework structure with modulemap

XCFRAMEWORK_PATH="$1"
VERSION="${2:-1.6.0}"

if [ -z "$XCFRAMEWORK_PATH" ]; then
  echo "Usage: $0 <path-to-OMSDK_Appodeal_Static.xcframework> [version]"
  echo "Example: $0 OMSDK_Appodeal_Static.xcframework 1.6.0"
  exit 1
fi

if [ ! -d "$XCFRAMEWORK_PATH" ]; then
  echo "Error: XCFramework not found at: $XCFRAMEWORK_PATH"
  exit 1
fi

echo "Repackaging Static XCFramework: $XCFRAMEWORK_PATH"
echo "Version: $VERSION"

for slice_dir in "$XCFRAMEWORK_PATH"/ios-* "$XCFRAMEWORK_PATH"/tvos-*; do
  if [ ! -d "$slice_dir" ]; then
    continue
  fi

  slice_name=$(basename "$slice_dir")
  echo "Processing slice: $slice_name"

  if [ -d "$slice_dir/OMSDK_Appodeal.framework" ]; then
    echo "  - Already has framework structure, skipping..."
    continue
  fi

  if [ ! -f "$slice_dir/libAppVerificationLibrary.a" ]; then
    echo "  - No .a file found, skipping..."
    continue
  fi

  framework_dir="$slice_dir/OMSDK_Appodeal.framework"
  echo "  - Creating framework structure..."
  mkdir -p "$framework_dir"

  echo "  - Moving static library..."
  mv "$slice_dir/libAppVerificationLibrary.a" "$framework_dir/OMSDK_Appodeal"

  if [ -d "$slice_dir/Headers" ]; then
    echo "  - Moving headers..."
    mv "$slice_dir/Headers" "$framework_dir/Headers"
  fi

  echo "  - Creating modulemap..."
  mkdir -p "$framework_dir/Modules"

  cat > "$framework_dir/Modules/module.modulemap" << 'EOF'
framework module OMSDK_Appodeal {
    umbrella header "OMIDImports.h"
    export *
    module * { export * }
}
EOF

  # Create Info.plist
  echo "  - Creating Info.plist..."
  cat > "$framework_dir/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>OMSDK_Appodeal</string>
    <key>CFBundleIdentifier</key>
    <string>com.iabtechlab.omsdk</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>OMSDK_Appodeal</string>
    <key>CFBundlePackageType</key>
    <string>FMWK</string>
    <key>CFBundleShortVersionString</key>
    <string>$VERSION</string>
    <key>CFBundleVersion</key>
    <string>1</string>
</dict>
</plist>
EOF

  echo "  - Done!"
done

# Update XCFramework Info.plist to reflect framework-based structure
echo ""
echo "Updating XCFramework Info.plist..."
cat > "$XCFRAMEWORK_PATH/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>AvailableLibraries</key>
	<array>
		<dict>
			<key>LibraryIdentifier</key>
			<string>tvos-arm64</string>
			<key>LibraryPath</key>
			<string>OMSDK_Appodeal.framework</string>
			<key>SupportedArchitectures</key>
			<array>
				<string>arm64</string>
			</array>
			<key>SupportedPlatform</key>
			<string>tvos</string>
		</dict>
		<dict>
			<key>LibraryIdentifier</key>
			<string>ios-arm64</string>
			<key>LibraryPath</key>
			<string>OMSDK_Appodeal.framework</string>
			<key>SupportedArchitectures</key>
			<array>
				<string>arm64</string>
			</array>
			<key>SupportedPlatform</key>
			<string>ios</string>
		</dict>
		<dict>
			<key>LibraryIdentifier</key>
			<string>ios-arm64_x86_64-simulator</string>
			<key>LibraryPath</key>
			<string>OMSDK_Appodeal.framework</string>
			<key>SupportedArchitectures</key>
			<array>
				<string>arm64</string>
				<string>x86_64</string>
			</array>
			<key>SupportedPlatform</key>
			<string>ios</string>
			<key>SupportedPlatformVariant</key>
			<string>simulator</string>
		</dict>
		<dict>
			<key>LibraryIdentifier</key>
			<string>tvos-arm64_x86_64-simulator</string>
			<key>LibraryPath</key>
			<string>OMSDK_Appodeal.framework</string>
			<key>SupportedArchitectures</key>
			<array>
				<string>arm64</string>
				<string>x86_64</string>
			</array>
			<key>SupportedPlatform</key>
			<string>tvos</string>
			<key>SupportedPlatformVariant</key>
			<string>simulator</string>
		</dict>
	</array>
	<key>CFBundlePackageType</key>
	<string>XFWK</string>
	<key>XCFrameworkFormatVersion</key>
	<string>1.0</string>
</dict>
</plist>
EOF

echo "✅ Repackaging complete!"
