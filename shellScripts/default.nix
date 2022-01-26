{ pkgs, ... }:
let
  nixFlakes = pkgs.callPackage ./nixFlakes.nix { inherit pkgs; };
  swaybar-status-line = pkgs.callPackage ./swaybar-status-line.nix { inherit pkgs; };
in [
  nixFlakes           # Allow usage of nix flakes with version of `nix` from nixpkgs-unstable
  swaybar-status-line # Self-explanatory
]
