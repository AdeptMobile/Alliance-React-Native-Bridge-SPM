#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$SCRIPT_DIR/../alliance-react-native-bridge/ios/dist"
PACKAGE_FILE="$SCRIPT_DIR/Package.swift"

if [ ! -d "$DIST_DIR" ]; then
    echo "Error: Distribution directory not found at $DIST_DIR"
    exit 1
fi

if [ ! -f "$PACKAGE_FILE" ]; then
    echo "Error: Package.swift not found at $PACKAGE_FILE"
    exit 1
fi

if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed."
    echo ""
    echo "Please install it using one of the following methods:"
    echo "  - macOS: brew install gh"
    echo "  - Or visit: https://cli.github.com/"
    echo ""
    exit 1
fi

ZIP_FILES=(
    "AllianceReactNativeBridge.xcframework.zip"
    "hermes.xcframework.zip"
    "BlazeSDK.xcframework.zip"
)

echo "Checking for required zip files..."
MISSING_FILES=()
for zip_file in "${ZIP_FILES[@]}"; do
    zip_path="$DIST_DIR/$zip_file"
    if [ ! -f "$zip_path" ]; then
        MISSING_FILES+=("$zip_file")
    fi
done

if [ ${#MISSING_FILES[@]} -gt 0 ]; then
    echo "Error: Required zip files not found. Please build them first:"
    for missing_file in "${MISSING_FILES[@]}"; do
        echo "  - $DIST_DIR/$missing_file"
    done
    exit 1
fi

echo "All required zip files found."
echo ""
echo "Current versions in Package.swift:"
grep -oE 'releases/download/[^/]+' "$PACKAGE_FILE" | sed 's|releases/download/||' | sort -u

echo ""
read -p "Enter new version (e.g., 1.1.22): " NEW_VERSION

if [ -z "$NEW_VERSION" ]; then
    echo "Error: Version cannot be empty"
    exit 1
fi

echo ""
echo "Calculating checksums..."

CHECKSUMS_ALLIANCE=""
CHECKSUMS_HERMES=""
CHECKSUMS_BLAZE=""

for zip_file in "${ZIP_FILES[@]}"; do
    zip_path="$DIST_DIR/$zip_file"
    checksum=$(swift package compute-checksum "$zip_path")
    
    if [[ "$zip_file" == "AllianceReactNativeBridge.xcframework.zip" ]]; then
        CHECKSUMS_ALLIANCE="$checksum"
    elif [[ "$zip_file" == "hermes.xcframework.zip" ]]; then
        CHECKSUMS_HERMES="$checksum"
    elif [[ "$zip_file" == "BlazeSDK.xcframework.zip" ]]; then
        CHECKSUMS_BLAZE="$checksum"
    fi
    
    echo "$zip_file: $checksum"
done

echo ""
read -p "Update Package.swift with new version and checksums? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Aborted"
    exit 0
fi

OLD_VERSION=$(grep -oE 'releases/download/[^/]+' "$PACKAGE_FILE" | sed 's|releases/download/||' | head -1)

sed -i '' "s|releases/download/$OLD_VERSION|releases/download/$NEW_VERSION|g" "$PACKAGE_FILE"

if [ -n "$CHECKSUMS_ALLIANCE" ]; then
    awk -v checksum="$CHECKSUMS_ALLIANCE" '
        /\.binaryTarget\(/ { in_binary=1 }
        in_binary && /name: "AllianceReactNativeBridge"/ { in_target=1 }
        in_target && /checksum:/ {
            sub(/checksum: "[^"]*"/, "checksum: \"" checksum "\"")
            in_target=0
            in_binary=0
        }
        /^[[:space:]]*\)/ && in_binary { in_binary=0; in_target=0 }
        { print }
    ' "$PACKAGE_FILE" > "$PACKAGE_FILE.tmp" && mv "$PACKAGE_FILE.tmp" "$PACKAGE_FILE"
fi

if [ -n "$CHECKSUMS_HERMES" ]; then
    awk -v checksum="$CHECKSUMS_HERMES" '
        /\.binaryTarget\(/ { in_binary=1 }
        in_binary && /name: "Hermes"/ { in_target=1 }
        in_target && /checksum:/ {
            sub(/checksum: "[^"]*"/, "checksum: \"" checksum "\"")
            in_target=0
            in_binary=0
        }
        /^[[:space:]]*\)/ && in_binary { in_binary=0; in_target=0 }
        { print }
    ' "$PACKAGE_FILE" > "$PACKAGE_FILE.tmp" && mv "$PACKAGE_FILE.tmp" "$PACKAGE_FILE"
fi

if [ -n "$CHECKSUMS_BLAZE" ]; then
    awk -v checksum="$CHECKSUMS_BLAZE" '
        /\.binaryTarget\(/ { in_binary=1 }
        in_binary && /name: "BlazeSDK"/ { in_target=1 }
        in_target && /checksum:/ {
            sub(/checksum: "[^"]*"/, "checksum: \"" checksum "\"")
            in_target=0
            in_binary=0
        }
        /^[[:space:]]*\)/ && in_binary { in_binary=0; in_target=0 }
        { print }
    ' "$PACKAGE_FILE" > "$PACKAGE_FILE.tmp" && mv "$PACKAGE_FILE.tmp" "$PACKAGE_FILE"
fi

echo ""
echo "Package.swift updated successfully"
echo ""

read -p "Create git tag and draft release? (y/n): " CREATE_RELEASE

if [ "$CREATE_RELEASE" != "y" ]; then
    echo "Done. Package.swift has been updated."
    exit 0
fi

if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 1
fi

git add "$PACKAGE_FILE"
if git diff --staged --quiet; then
    echo "No changes to commit"
else
    git commit -m "Update to version $NEW_VERSION"
    git push origin HEAD
fi

if git rev-parse "$NEW_VERSION" >/dev/null 2>&1; then
    echo "Tag $NEW_VERSION already exists. Skipping tag creation."
else
    git tag "$NEW_VERSION"
    git push origin "$NEW_VERSION"
fi

echo ""
read -p "Enter release title (default: Release $NEW_VERSION): " RELEASE_TITLE
RELEASE_TITLE=${RELEASE_TITLE:-"Release $NEW_VERSION"}

read -p "Enter release notes (optional): " RELEASE_NOTES

echo ""
echo "Creating draft release..."

UPLOAD_FILES=()
for zip_file in "${ZIP_FILES[@]}"; do
    zip_path="$DIST_DIR/$zip_file"
    if [ -f "$zip_path" ]; then
        UPLOAD_FILES+=("$zip_path")
    fi
done

if [ ${#UPLOAD_FILES[@]} -eq 0 ]; then
    echo "Warning: No zip files found to upload"
else
    gh release create "$NEW_VERSION" \
        --title "$RELEASE_TITLE" \
        --notes "$RELEASE_NOTES" \
        --draft \
        "${UPLOAD_FILES[@]}"
fi

echo ""
echo "Draft release created successfully!"
echo "You can review and publish it at: https://github.com/AdeptMobile/Alliance-React-Native-Bridge-SPM/releases"

