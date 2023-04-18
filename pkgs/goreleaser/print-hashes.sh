#!/usr/bin/env bash
version=$1
base="https://github.com/goreleaser/goreleaser/releases/download"

echo "suffixToHash = {"
echo "    Linux_x86_64 = \"$(nix-prefetch-url $base/$version/goreleaser_Linux_x86_64.tar.gz 2>/dev/null)\";"
echo "    Linux_arm64 = \"$(nix-prefetch-url $base/$version/goreleaser_Linux_arm64.tar.gz 2>/dev/null)\";"
echo "    Darwin_x86_64 = \"$(nix-prefetch-url $base/$version/goreleaser_Darwin_x86_64.tar.gz 2>/dev/null)\";"
echo "    Darwin_arm64 = \"$(nix-prefetch-url $base/$version/goreleaser_Darwin_arm64.tar.gz 2>/dev/null)\";"
echo "};"



