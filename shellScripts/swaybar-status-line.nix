{ pkgs, ... }:
let
  date = "${pkgs.dateutils}/bin/date";
  volume = "${pkgs.pamixer}/bin/pamixer";
  head = "${pkgs.coreutils}/bin/head";
  sort = "${pkgs.coreutils}/bin/sort";
  awk = "${pkgs.gawk}/bin/awk";
  sensors = "${pkgs.lm_sensors}/bin/sensors";
in
  pkgs.writeShellScriptBin "swaybar-status-line.sh" ''
    # Timestamp
    d=$(${date} +'%a %F %R:%S %Z')

    # Temperature
    ctemp=$(${sensors} | awk '/Package/{ print $4 }' )

    # Volume
    vol=$(${volume} --get-volume-human)

    # Battery (minimum value):
    bat=$(${sort} -n /sys/class/power_supply/BAT*/capacity | head -n 1)

    # Final result (status bar output):
    echo VOL: "$vol | " CPU: "$ctemp | " BAT: "$bat% | $d"
  ''
