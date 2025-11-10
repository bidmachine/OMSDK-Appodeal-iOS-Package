#!/usr/bin/env bash
set -euo pipefail

# ---------------------------------------------------------
# CONFIG
# ---------------------------------------------------------

OMSDK_VERSION="${OMSDK_VERSION:-1.6.0}"

S3_BUCKET="${S3_BUCKET:-appodeal-ios}"
S3_PREFIX="${S3_PREFIX:-external-sdks/OMSDK_Appodeal/${OMSDK_VERSION}}"

UPLOAD_TO_S3="${UPLOAD_TO_S3:-false}"

OMJS_RELATIVE_PATH="OMSDK/Service/omsdk-v1.js"

# ---------------------------------------------------------
# PATHS
# ---------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKDIR="$SCRIPT_DIR/omsdk_build"

# Cleanup
rm -rf "$WORKDIR"
mkdir -p "$WORKDIR"

echo "Working directory: $WORKDIR"

REPACKAGE_SCRIPT="$SCRIPT_DIR/repackage_static_framework.sh"

if [[ ! -x "$REPACKAGE_SCRIPT" ]]; then
  echo "ERROR: repackage script not found or not executable: $REPACKAGE_SCRIPT"
  echo "Make sure it is next to omsdk_setup.sh and run: chmod +x repackage_static_framework.sh"
  exit 1
fi

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <path-to-omsdk-ios-zip>"
  echo "Example: $0 omsdk-ios-1.zip"
  exit 1
fi

INPUT_ZIP="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"

if [[ ! -f "$INPUT_ZIP" ]]; then
  echo "Input zip not found: $INPUT_ZIP"
  exit 1
fi

# ---------------------------------------------------------
# 1. Unzip
# ---------------------------------------------------------

unzip -q "$INPUT_ZIP" -d "$WORKDIR" -x '__MACOSX/*' '*/._*'

# Derive root dir name from the archive name (without .zip extension)
ARCHIVE_BASENAME="$(basename "$INPUT_ZIP" .zip)"
ROOT_DIR="$WORKDIR/$ARCHIVE_BASENAME"
echo "Detected root dir: $ROOT_DIR"

if [[ ! -d "$ROOT_DIR" ]]; then
  echo "ERROR: Expected directory not found: $ROOT_DIR"
  exit 1
fi

DYNAMIC_XCFRAMEWORK="$(find "$ROOT_DIR" -maxdepth 1 -type d -name 'OMSDK_Appodeal.xcframework' | head -n1 || true)"
STATIC_XCFRAMEWORK="$(find "$ROOT_DIR" -maxdepth 1 -type d \( -name 'OMSDK_Static_Appodeal.xcframework' -o -name 'OMSDK-Static_Appodeal.xcframework' \) | head -n1 || true)"

if [[ -z "$DYNAMIC_XCFRAMEWORK" ]]; then
  echo "ERROR: Dynamic OMSDK_Appodeal.xcframework not found in $ROOT_DIR"
  exit 1
fi

if [[ -z "$STATIC_XCFRAMEWORK" ]]; then
  echo "ERROR: Static OMSDK_*_Appodeal.xcframework not found in $ROOT_DIR"
  exit 1
fi

echo "Dynamic XCFramework: $DYNAMIC_XCFRAMEWORK"
echo "Static  XCFramework: $STATIC_XCFRAMEWORK"

# ---------------------------------------------------------
# 1.5 Repack XCFramework to framework structure
# ---------------------------------------------------------

echo
echo "Repackaging static XCFramework via: $REPACKAGE_SCRIPT"
"$REPACKAGE_SCRIPT" "$STATIC_XCFRAMEWORK" "$OMSDK_VERSION"
echo "Static XCFramework repackaged."

# ---------------------------------------------------------
# 2. Prepare to upload S3/Pods and S3/Carthage
# ---------------------------------------------------------

OUTPUT_DIR="$WORKDIR/output"
mkdir -p "$OUTPUT_DIR"

S3_LOCAL_ROOT="$OUTPUT_DIR/S3"
PODS_DIR="$S3_LOCAL_ROOT/Pods"
CARTHAGE_DIR="$S3_LOCAL_ROOT/Carthage"
SPM_DIR="$S3_LOCAL_ROOT/SPM"

mkdir -p "$PODS_DIR" "$CARTHAGE_DIR" "$SPM_DIR"

# 2.1 Pods zip:
# OMSDK_Appodeal.zip
#   ├─ Static/OMSDK_Appodeal.xcframework
#   └─ Dynamic/OMSDK_Appodeal.xcframework

PODS_PAYLOAD="$(mktemp -d "$WORKDIR/pods_payload.XXXX")"
mkdir -p "$PODS_PAYLOAD/Static" "$PODS_PAYLOAD/Dynamic"

cp -R "$STATIC_XCFRAMEWORK"  "$PODS_PAYLOAD/Static/OMSDK_Appodeal.xcframework"
cp -R "$DYNAMIC_XCFRAMEWORK" "$PODS_PAYLOAD/Dynamic/OMSDK_Appodeal.xcframework"

(
  cd "$PODS_PAYLOAD"
  zip -qry "$PODS_DIR/OMSDK_Appodeal.zip" Static Dynamic
)

echo "Created Pods zip at:     $PODS_DIR/OMSDK_Appodeal.zip"

# 2.2 Carthage zip:
# OMSDK_Appodeal.zip
#   ├─ OMSDK_Appodeal_Static.xcframework
#   └─ OMSDK_Appodeal_Dynamic.xcframework

CARTHAGE_PAYLOAD="$(mktemp -d "$WORKDIR/carthage_payload.XXXX")"

cp -R "$STATIC_XCFRAMEWORK"  "$CARTHAGE_PAYLOAD/OMSDK_Appodeal_Static.xcframework"
cp -R "$DYNAMIC_XCFRAMEWORK" "$CARTHAGE_PAYLOAD/OMSDK_Appodeal_Dynamic.xcframework"

(
  cd "$CARTHAGE_PAYLOAD"
  zip -qry "$CARTHAGE_DIR/OMSDK_Appodeal.zip" \
      OMSDK_Appodeal_Static.xcframework \
      OMSDK_Appodeal_Dynamic.xcframework
)

echo "Created Carthage zip at: $CARTHAGE_DIR/OMSDK_Appodeal.zip"

# 2.3 SPM zip (static only):
# OMSDK_Appodeal.zip
#   └─ OMSDK_Appodeal.xcframework

SPM_PAYLOAD="$(mktemp -d "$WORKDIR/spm_payload.XXXX")"

cp -R "$STATIC_XCFRAMEWORK" "$SPM_PAYLOAD/OMSDK_Appodeal.xcframework"

(
  cd "$SPM_PAYLOAD"
  zip -qry "$SPM_DIR/OMSDK_Appodeal.zip" OMSDK_Appodeal.xcframework
)

echo "Created SPM zip at:      $SPM_DIR/OMSDK_Appodeal.zip"

# ---------------------------------------------------------
# 3. Generate byte array from omsdk-v1.js
# ---------------------------------------------------------

OMJS_SOURCE="$ROOT_DIR/$OMJS_RELATIVE_PATH"
if [[ ! -f "$OMJS_SOURCE" ]]; then
  echo "ERROR: JS file not found: $OMJS_SOURCE"
  exit 1
fi

BYTEARRAY_DIR="$OUTPUT_DIR/bytearray"
mkdir -p "$BYTEARRAY_DIR"

OMJS_H="$BYTEARRAY_DIR/omjs.h"
echo "Generating omjs.h..."

{
  xxd -i "$OMJS_SOURCE" \
    | sed -e 's/^unsigned char .*/const unsigned char __StackRendering_omsdk_v1_js[] = {/' \
          -e '/^unsigned int /d'

  echo

  xxd -i "$OMJS_SOURCE" \
    | sed -n 's/^unsigned int .* = \([0-9][0-9]*\);/const unsigned int __StackRendering_omsdk_v1_js_len = \1;/p'

  echo
} > "$OMJS_H"

echo "Created: $OMJS_H"

# ---------------------------------------------------------
# 4. Upload to S3 (if enabled)
# ---------------------------------------------------------

echo "Upload enabled: $UPLOAD_TO_S3"

if [[ "$UPLOAD_TO_S3" == "true" ]]; then
  echo "Uploading to S3 (bucket: $S3_BUCKET, prefix: $S3_PREFIX)..."

  aws s3 cp "$PODS_DIR/OMSDK_Appodeal.zip" \
    "s3://${S3_BUCKET}/${S3_PREFIX}/Pods/OMSDK_Appodeal.zip" \
    --acl public-read

  aws s3 cp "$CARTHAGE_DIR/OMSDK_Appodeal.zip" \
    "s3://${S3_BUCKET}/${S3_PREFIX}/Carthage/OMSDK_Appodeal.zip" \
    --acl public-read

  aws s3 cp "$SPM_DIR/OMSDK_Appodeal.zip" \
    "s3://${S3_BUCKET}/${S3_PREFIX}/SPM/OMSDK_Appodeal.zip" \
    --acl public-read
fi

echo
echo "All done."
echo "Local S3 layout is in: $S3_LOCAL_ROOT"
echo "Pods:                  $PODS_DIR/OMSDK_Appodeal.zip"
echo "Carthage:              $CARTHAGE_DIR/OMSDK_Appodeal.zip"
echo "SPM:                   $SPM_DIR/OMSDK_Appodeal.zip"
echo "Byte array:            $BYTEARRAY_DIR/omjs.h"
