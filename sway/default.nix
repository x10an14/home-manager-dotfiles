{config, pkgs, ...}:
let
  mod = config.wayland.windowManager.sway.config.modifier;
  gui-packages = with pkgs; [
    firefox
    tridactyl-native
  ];

  # Named workspaces
  ws2 = "2: Web";
  ws3 = "3: Notes";
  ws5 = "5: IDE";
  ws8 = "8: Chats";
  ws10 = "10: Utils";

in {
  imports = [
    ./swaylock/default.nix
    ./wob/default.nix
    ./brightnessctl.nix
    ./swaybar-status-line.nix
  ];

  home = {
    packages = gui-packages;
  };
  services.swayidle.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = "Mod4"; # Super key
      workspaceAutoBackAndForth = true;
      input = {
        "*" = {
          xkb_layout = "no";
          xkb_options = "caps:escape";
        };
      };
      bars = [
        {
          fonts = {
            names = [ "hack" "FontAwesome5Free" ];
            style = "Regular";
            size = 11.0;
          }
        }
      ];
      fonts = {
        names = [ "hack" "FontAwesome5Free" ];
        style = "Bold";
      };
      keybindings = {
        "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec ${pkgs.bemenu}/bin/bemenu-run | ${pkgs.findutils}/bin/xargs ${pkgs.sway}/bin/swaymsg exec --";
        "${mod}+Shift+r" = "reload";
        "${mod}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

        # Moving windows/focus around
        "${mod}+Left" = "focus left";
        "${mod}+Shift+Left" = "move left";
        "${mod}+Right" = "focus right";
        "${mod}+Shift+Right" = "move right";
        "${mod}+Up" = "focus up";
        "${mod}+Shift+Up" = "move up";
        "${mod}+Down" = "focus down";
        "${mod}+Shift+Down" = "move down";
        
        # Move between workspaces
        "${mod}+1" = "workspace 1";
        "${mod}+Shift+1" = "move container to workspace 1";
        "${mod}+2" = "workspace ${ws2}";
        "${mod}+Shift+2" = "move container to workspace ${ws2}";
        "${mod}+3" = "workspace ${ws3}";
        "${mod}+Shift+3" = "move container to workspace ${ws3}";
        "${mod}+4" = "workspace 4";
        "${mod}+Shift+4" = "move container to workspace 4";
        "${mod}+5" = "workspace ${ws5}";
        "${mod}+Shift+5" = "move container to workspace ${ws5}";
        "${mod}+6" = "workspace 6";
        "${mod}+Shift+6" = "move container to workspace 6";
        "${mod}+7" = "workspace 7";
        "${mod}+Shift+7" = "move container to workspace 7";
        "${mod}+8" = "workspace ${ws8}";
        "${mod}+Shift+8" = "move container to workspace ${ws8}";
        "${mod}+9" = "workspace 9";
        "${mod}+Shift+9" = "move container to workspace 9";
        "${mod}+0" = "workspace ${ws10}";
        "${mod}+Shift+0" = "move container to workspace ${ws10}";

        # Layout manipulation
        "${mod}+h" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggle split";
        "${mod}+f" = "fullscreen";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+p" = "focus parent";
      };

      startup = [
      ];
    };
  };
}
