{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    # Colors managed by Stylix

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 8;
      margin-top = 6;
      margin-left = 8;
      margin-right = 8;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "tray"
        "network"
        "pulseaudio"
        "battery"
        "custom/notification"
      ];

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          active = "●";
          default = "○";
          urgent = "◉";
        };
        on-click = "activate";
        sort-by-number = true;
      };

      "hyprland/window" = {
        max-length = 40;
        separate-outputs = true;
      };

      clock = {
        format = "{:%I:%M %p  |  %a, %b %d}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      network = {
        format-wifi = "  {signalStrength}%";
        format-ethernet = " ";
        format-disconnected = "⚠ ";
        tooltip-format = "{ifname}: {ipaddr}/{cidr}\n{essid} ({signalStrength}%)";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "  muted";
        format-icons = {
          default = [
            " "
            " "
            " "
          ];
        };
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      battery = {
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-icons = [
          " "
          " "
          " "
          " "
          " "
        ];
        states = {
          warning = 30;
          critical = 15;
        };
      };

      tray = {
        spacing = 8;
      };

      "custom/notification" = {
        format = " ";
        on-click = "swaync-client -t -sw";
        tooltip = false;
      };
    };

    style = ''
      * {
        font-family: "Inter", "JetBrains Mono Nerd Font", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: alpha(@base, 0.8);
        border-radius: 12px;
        border: 1px solid alpha(@surface1, 0.5);
      }

      #workspaces button {
        padding: 0 5px;
        border-radius: 8px;
        color: @subtext0;
      }

      #workspaces button.active {
        color: @peach;
      }

      #workspaces button.urgent {
        color: @red;
      }

      #window {
        color: @text;
        padding: 0 8px;
      }

      #clock {
        color: @text;
        padding: 0 12px;
      }

      #network, #pulseaudio, #battery, #tray, #custom-notification {
        padding: 0 8px;
        color: @subtext1;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @yellow;
      }

      #battery.critical:not(.charging) {
        color: @red;
      }

      tooltip {
        background: @base;
        border: 1px solid @surface1;
        border-radius: 8px;
      }
    '';
  };
}
