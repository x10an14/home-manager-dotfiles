{ config, pkgs, ... }:

let
  nixFlakes = pkgs.callPackage ./nixFlakes.nix { inherit config pkgs; };
  myPackages = with pkgs; [
    pyspread
  ];
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home = {
    packages = myPackages ++ [ nixFlakes ];
  };
}
