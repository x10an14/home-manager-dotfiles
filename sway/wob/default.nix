{config, pkgs, lib, ...}:
let
  sway-enabled = config.wayland.windowManager.sway.enable;
  start-wob = pkgs.writeShellApplication {
    name = "start-wob.sh";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      gawk
      gnugrep
      procps
      wob
    ];
    text = ''
      # This script depends on WOBSOCK environment variable being set and being idempotent per user.

      function kill_previous_invocations() {
          set +e
          # Kill tail
          ${pkgs.procps}/bin/ps aux |
              ${pkgs.gawk}/bin/awk '$0~v{ print $2 }' v="/tail -f $WOBSOCK" |
              ${pkgs.findutils}/bin/xargs ${pkgs.coreutils}/bin/kill -9

          # Kill earlier invocations of self
          ${pkgs.procps}/bin/pgrep "$(${pkgs.coreutils}/bin/basename "$0")" |
              ${pkgs.gnugrep}/bin/grep -v "$1" |
              ${pkgs.findutils}/bin/xargs ${pkgs.coreutils}/bin/kill -9

          # Kill wob
          ${pkgs.procps}/bin/pkill -x wob

          # Delete fifo
          ${pkgs.coreutils}/bin/rm -f "$WOBSOCK"
          set -e
      }

      # Restart - make idempotent
      kill_previous_invocations $$

      # Start anew
      ${pkgs.coreutils}/bin/mkfifo "$WOBSOCK" && ${pkgs.coreutils}/bin/tail -f "$WOBSOCK" | ${pkgs.wob}/bin/wob
    '';
  };
in {
  home = {
    packages = [start-wob];
    sessionVariables.WOBSOCK = "$XDG_RUNTIME_DIR/wob.sock";
  };
  wayland.windowManager.sway.config.startup = lib.mkIf (sway-enabled == true) [
    { command = "${start-wob}/bin/start-wob.sh"; always = true; }
  ];
}
