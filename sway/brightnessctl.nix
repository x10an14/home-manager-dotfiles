{config, pkgs, lib, ...}:
let
  sway-enabled = config.wayland.windowManager.sway.enable;
  swayidle-enabled = config.services.swayidle.enable;
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  refresh-keyboard-brightness = pkgs.writeShellApplication {
    name = "refresh-keyboard-brightness";
    runtimeInputs = [ pkgs.brightnessctl pkgs.coreutils ];
    text = ''
      ${brightnessctl} --device='tpacpi::kbd_backlight' set 0
      #${pkgs.coreutils}/bin/sleep
      ${brightnessctl} --device='tpacpi::kbd_backlight' --restore
    '';
  };
  refresh = "${refresh-keyboard-brightness}/bin/refresh-keyboard-brightness";
  awk-extract-number = "${pkgs.gawk}/bin/awk -F, '{gsub(\",\",\"\"); print $4}'";
in {
  services.swayidle.events = lib.mkIf (swayidle-enabled == true) [
    {event = "after-resume"; command = refresh;}
  ];

  wayland.windowManager.sway.config = lib.mkIf (sway-enabled == true) {
    startup = [
      {command = refresh; always = true;}
    ];
    keybindings = {
      XF86MonBrightnessUp = "${brightnessctl} --machine-readable set +5% | ${awk-extract-number} > $WOBSOCK";
      XF86MonBrightnessDown = "${brightnessctl} --machine-readable set 5%- | ${awk-extract-number} > $WOBSOCK";
    };
  };
}
