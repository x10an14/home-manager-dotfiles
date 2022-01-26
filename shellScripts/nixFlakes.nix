{ pkgs, ... }:
  pkgs.writeShellScriptBin "nixFlakes" ''
    exec ${pkgs.unstable.nixFlakes}/bin/nix --experimental-features "nix-command flakes" "$@"
  ''
