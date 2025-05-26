{
  description = "A very basic flake";

  outputs =
    { self }:
    {
      nixosModules.howdy = { ... }: { };
      overlays.default = self.overlays.howdy;
      overlays.howdy = final: prev: {
        linux-enable-ir-emitter = final.callPackage ./linux-enable-ir-emitter.nix { };
        howdy = final.callPackage ./howdy/package.nix { };
      };
    };
}
