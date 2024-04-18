#!/bin/sh
wget -O ./pkgs/gopls/default.nix https://raw.githubusercontent.com/NixOS/nixpkgs/master/pkgs/development/tools/language-servers/gopls/default.nix
sed -e 's/buildGoModule/buildGo122Module/g' -i'' ./pkgs/gopls/default.nix
nix-build -A gopls
