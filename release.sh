#!/bin/bash
# Universal (Apple Silicon + Intel) release derler, .app paketler, ad-hoc imzalar
# ve StatusAppBar.zip üretir. Hem CI (GitHub Actions) hem de elle kullanılır.
set -euo pipefail

cd "$(dirname "$0")"

echo "▸ Universal release derleniyor (arm64 + x86_64)..."
swift build -c release --arch arm64 --arch x86_64

BIN="$(swift build -c release --arch arm64 --arch x86_64 --show-bin-path)/StatusAppBar"
APP="StatusAppBar.app"

echo "▸ .app paketleniyor..."
rm -rf "$APP" StatusAppBar.zip
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/StatusAppBar"
cp Info.plist "$APP/Contents/Info.plist"

# Ad-hoc imza (sertifika gerektirmez; yerel/CI çalıştırması için yeterli).
codesign --force --deep --sign - "$APP"

echo "▸ Zip'leniyor (ditto, bundle yapısını korur)..."
ditto -c -k --keepParent "$APP" StatusAppBar.zip

echo "✓ StatusAppBar.zip hazır"
lipo -info "$APP/Contents/MacOS/StatusAppBar"
