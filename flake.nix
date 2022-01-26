{
  description = "Nix Flake for x10an14's non-NixOS nix settings.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    homeManager = {
      # See `nix registry list` for `flake:X` aliases
      url = "flake:home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self
    , nixpkgs
    , nixpkgs-unstable
    , homeManager
    , ...
  }: {
    homeConfigurations = {
      x10an14 = homeManager.lib.homeManagerConfiguration {
        # Home-manager 'must-haves' on this level, the rest is in `home.nix` and down...
        system = "x86_64-linux";
        homeDirectory = "/home/x10an14";
        username = "x10an14";
        stateVersion = "22.05";

        # Allow reference/installation of unstable packages with `pkgs.unstable.<package>`
        configuration = {config, pkgs, ...}: let
          overlay-unstable = final: prev: {
            unstable = nixpkgs-unstable.legacyPackages.x86-64-linux;
          };
        in {
          nixpkgs = {
            # Complete the implementation of `pkgs.unstable.<package>`
            overlays = [ overlay-unstable ];
            config.allowUnfree = true;
          };

          # Home-manager settings independent from system
          imports = [
            ./home.nix
          ];
        };
      };
    };
  };
}
