# Howdy module for NixOS
This is a nixos module that enables [howdy] based on the [PR on nixpkgs](https://github.com/NixOS/nixpkgs/pull/216245).
I created this for my self to easily install howdy until the PR get's merged.

## How to enable
Add these to your flake inputs.

```nix
{
  inputs.howdy-module.url = "github:pineapplehunter/howdy-module";
}
```

Add the nixosModule to your configuration and enable the services
```nix
{...}: {
  imports = [
    howdy-module.nixosModules.default
  ];

  services.howdy.enable = true;
  services.linux-enable-ir-emitter.enable = true;
}
```


[howdy]: https://github.com/boltgolt/howdy

