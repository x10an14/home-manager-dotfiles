{config, pkgs, lib, ...}:
let
 sway-enabled = config.wayland.windowManager.sway.enable;
 swaylock-bin = "${pkgs.swaylock-effects}/bin/swaylock";
in {
  xdg.configFile."swaylock/config" = {
    source = ./swaylock.config;
  };

  # See https://github.com/NixOS/nixpkgs/issues/143365
  home.packages = [pkgs.swaylock-effects];

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = swaylock-bin; }
      { event = "lock"; command = swaylock-bin; }
    ];
  };
  wayland.windowManager.sway.config.keybindings = lib.mkIf (sway-enabled == true) {
    "Ctrl+Mod1+l" = "swaylock";
  };
}
