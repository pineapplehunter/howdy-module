# for nix-update compatibility
{ ... }@args:
let
  # for pinning nixpkgs
  npins = import ./npins;
  flake = (import npins.flake-compat { src = ./.; }).defaultNix;
  overlays = [ flake.overlays.default ];
  pkgs = import npins.nixpkgs ({ inherit overlays; } // args);
in
{
  inherit (pkgs)
    howdy
    linux-enable-ir-emitter
    ;
}
