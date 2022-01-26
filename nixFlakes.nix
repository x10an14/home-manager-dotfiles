{ pkgs, ... }:
  pkgs.writeShellScriptBin "nixFlakes" ''
    exec ${pkgs.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
  ''
