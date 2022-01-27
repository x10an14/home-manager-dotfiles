{ pkgs, ... }:
let
  nixFlakes = pkgs.callPackage ./nixFlakes.nix { inherit pkgs; };
in [
  nixFlakes           # Allow usage of nix flakes with version of `nix` from nixpkgs-unstable
]
