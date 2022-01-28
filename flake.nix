{
  description = "Nix Flake for x10an14's non-NixOS nix settings.";

  inputs = {
    nixpkgs.url = "flake:nixpkgs";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-unstable";
    homeManager = {
      # See `nix registry list` for `flake:X` aliases
      url = "flake:home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self
    , nixpkgs
    , nixpkgs-stable
    , homeManager
    , ...
  }: let
    system = "x86_64-linux";
  in {
    homeConfigurations = {
      x10an14 = homeManager.lib.homeManagerConfiguration {
        # Home-manager 'must-haves' on this level, the rest is in `home.nix` and down...
        system = system;
        homeDirectory = "/home/x10an14";
        username = "x10an14";
        stateVersion = "22.05";

        # Allow reference/installation of unstable packages with `pkgs.unstable.<package>`
        configuration = {config, pkgs, ...}: let
          overlay-stable = final: prev: {
            unstable = nixpkgs-stable.legacyPackages."${system}";
          };
        in {
          nixpkgs = {
            # Complete the implementation of `pkgs.unstable.<package>`
            overlays = [ overlay-stable ];
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
