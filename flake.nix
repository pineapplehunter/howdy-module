{
  description = "A very basic flake";

  outputs =
    { self }:
    {
      nixosModules.default = self.nixosModules.howdy;
      nixosModules.howdy =
        { ... }:
        {
          imports = [
            ./module/howdy.nix
            ./module/linux-enable-ir-emitter.nix
            ./module/security.nix
          ];

          nixpkgs.overlays = [ self.overlays.default ];
        };

      overlays.default = self.overlays.howdy;
      overlays.howdy =
        final: prev:
        prev.lib.packagesFromDirectoryRecursive {
          inherit (final) callPackage;
          directory = ./pkgs;
        };
    };
}
