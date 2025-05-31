# for nix-update compatibility
{ ... }@args:
let
  npins = import ./npins;
  pkgs = import npins.nixpkgs args;
in
pkgs.lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage;
  directory = ./pkgs;
}
