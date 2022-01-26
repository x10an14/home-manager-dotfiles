{ config, pkgs, ... }:

let
  scripts = pkgs.callPackage ./shellScripts { inherit config pkgs; };
  myPackages = with pkgs; [
    pyspread
  ];
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home = {
    packages = myPackages ++ scripts;
  };
}
