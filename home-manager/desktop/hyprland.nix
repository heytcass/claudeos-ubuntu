# Hyprland compositor — keybindings mapped from Niri for muscle memory compatibility
{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    brightnessctl
    playerctl
    grim
    slurp
    swappy # screenshot annotation
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # Colors managed by Stylix

    settings = {
      "$mod" = "SUPER";

      # Monitor defaults — per-host overrides in hosts/*.nix
      monitor = [ ",preferred,auto,1.0" ];

      # Input — Colemak layout
      input = {
        kb_layout = "us";
        kb_variant = "colemak";
        follow_mouse = 2;
        repeat_rate = 30;
        repeat_delay = 300;
        touchpad = {
          clickfinger_behavior = true;
          natural_scroll = true;
          tap-to-click = false;
        };
      };

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 1;
        resize_on_border = true;
        extend_border_grab_area = 10;
        layout = "dwindle";
      };

      dwindle = {
        preserve_split = true;
      };

      decoration = {
        rounding = 12;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        dim_inactive = true;
        dim_strength = 0.025;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = {
          enabled = true;
          passes = 2;
          size = 6;
          ignore_opacity = true;
        };
      };

      animations = {
        enabled = true;
        first_launch_animation = true;
      };

      animation = [
        "windows, 1, 6, wind, slide"
        "windowsIn, 1, 6, winIn, slide"
        "windowsOut, 1, 5, winOut, slide"
        "windowsMove, 1, 5, wind, slide"
        "border, 1, 10, liner"
        "fade, 1, 10, default"
        "workspaces, 1, 5, wind"
      ];

      bezier = [
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
        vfr = true;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = false;
      };

      xwayland.force_zero_scaling = true;

      # ── Startup ──────────────────────────────────────────────
      exec-once = [
        # Clipboard history
        "${lib.getExe pkgs.wl-clipboard} --watch ${lib.getExe pkgs.cliphist} store"
        # GNOME dark mode for GTK portals
        "dconf write /org/gnome/desktop/wm/preferences/button-layout \"':appmenu'\""
      ];

      # ── Keybindings ──────────────────────────────────────────
      # Mapped from Niri — same muscle memory
      bind = [
        # Application launchers
        "$mod, Return, exec, ghostty"
        "$mod, C, exec, ghostty --class=claude-quick -e claude" # Claude quick
        "CTRL ALT, Space, exec, claude-desktop" # Claude Desktop
        "$mod, D, exec, fuzzel" # App launcher

        # Claude integration
        "$mod, A, exec, claude-ask-desktop" # Quick question → notification
        "$mod SHIFT, A, exec, claude-screenshot" # Screenshot analysis → notification
        "$mod CTRL, A, exec, claude-screenshot-interactive" # Screenshot → terminal

        # Window management (same as Niri)
        "$mod, Q, killactive"
        "$mod, F, fullscreen, 1" # Maximize (not true fullscreen)
        "$mod SHIFT, F, fullscreen, 0" # True fullscreen
        "$mod, V, togglefloating"
        "$mod, P, pseudo" # Dwindle pseudo-tile

        # Focus (Mod+Arrow — same as Niri)
        "$mod, Left, movefocus, l"
        "$mod, Right, movefocus, r"
        "$mod, Up, movefocus, u"
        "$mod, Down, movefocus, d"

        # Move windows (Mod+Shift+Arrow — same as Niri)
        "$mod SHIFT, Left, movewindow, l"
        "$mod SHIFT, Right, movewindow, r"
        "$mod SHIFT, Up, movewindow, u"
        "$mod SHIFT, Down, movewindow, d"

        # Workspace switching (Mod+1-5 — same as Niri)
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"

        # Move to workspace (Mod+Shift+1-5 — same as Niri)
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"

        # Workspace cycling (Ctrl+Alt+Arrow — from Niri's Mod+Up/Down)
        "CTRL ALT, Left, workspace, e-1"
        "CTRL ALT, Right, workspace, e+1"

        # Alt-tab cycling
        "ALT, Tab, cyclenext"
        "ALT, Tab, bringactivetotop"
        "ALT SHIFT, Tab, cyclenext, prev"
        "ALT SHIFT, Tab, bringactivetotop"

        # Lock screen
        "$mod, L, exec, hyprlock"

        # Screenshots (same keys as Niri)
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -" # Region
        "CTRL, Print, exec, grim - | swappy -f -" # Full screen
        "ALT, Print, exec, hyprctl activewindow -j | jq -r '.at,.size' | grim -g - - | swappy -f -" # Window

        # Clipboard history (Mod+Shift+C — same as Niri)
        "$mod SHIFT, C, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
      ];

      # Mouse bindings
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      # Media keys (work when locked too)
      bindl = [
        ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
        ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
        ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
      ];

      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];

      # Window rules
      windowrulev2 = [
        # Claude quick-launch: floating
        "float, class:^(claude-quick)$"
        "center, class:^(claude-quick)$"
        "size 900 600, class:^(claude-quick)$"

        # Floating dialogs
        "float, title:(Open|Progress|Save File)"
        "center, title:(Open|Progress|Save File)"
        "float, class:(xdg-desktop-portal-gtk)"
        "center, class:(xdg-desktop-portal-gtk)"

        # No shadows on tiled windows
        "noshadow, floating:0"
      ];

      # Persistent workspaces
      workspace = [
        "1, persistent:true"
        "2, persistent:true"
        "3, persistent:true"
        "4, persistent:true"
        "5, persistent:true"
      ];

      layerrule = [
        "blur, launcher"
        "ignorezero, launcher"
        "blur, swaync-control-center"
        "blur, swaync-notification-window"
        "ignorealpha 0.7, swaync-control-center"
        "ignorealpha 0.7, swaync-notification-window"
      ];
    };

    systemd = {
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
    xwayland.enable = true;
  };

  # Idle management — lock, DPMS off, suspend
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "hyprlock";
      }
      {
        timeout = 330;
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
      {
        timeout = 900;
        command = "systemctl suspend";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "hyprlock";
      }
    ];
  };

  # XDG portal config for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config.common.default = "gtk";
    configPackages = [ pkgs.hyprland ];
  };
}
