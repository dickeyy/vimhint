#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <app_path> <output_dmg_path> <volume_name>"
  exit 1
fi

APP_PATH="$1"
OUTPUT_DMG="$2"
VOLUME_NAME="$3"

if [[ ! -d "$APP_PATH" ]]; then
  echo "App not found: $APP_PATH"
  exit 1
fi

STAGING_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

cp -R "$APP_PATH" "$STAGING_DIR/"
ln -s /Applications "$STAGING_DIR/Applications"

mkdir -p "$(dirname "$OUTPUT_DMG")"
rm -f "$OUTPUT_DMG"

hdiutil create \
  -volname "$VOLUME_NAME" \
  -srcfolder "$STAGING_DIR" \
  -ov \
  -format UDZO \
  "$OUTPUT_DMG"

echo "Created DMG: $OUTPUT_DMG"
