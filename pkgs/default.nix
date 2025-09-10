{
  pkgs,
  lib,
}:
# ./default.nix gets included as default, so remove it from the final package set
builtins.removeAttrs (lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage;
  directory = ./.;
}) ["default"]
