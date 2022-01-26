{ config, pkgs, ... }:

let
  myPackages = with pkgs; [
    pyspread
  ];
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home = {
    packages = myPackages;
  };
}
