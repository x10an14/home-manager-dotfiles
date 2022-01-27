{config, lib, ...}:
let
  sway-enabled = config.wayland.windowManager.sway.enable;
in {
  config = lib.mkIf (config.hostname == "bits-laptop") {

    wayland.windowManager.sway.config = lib.mkIf (sway-enabled == true) {
      output = {
        eDP-1 = {resolution = "2560x1440"; position = "0,0"; scale = "1.5";};
      };
    };
  };
}
