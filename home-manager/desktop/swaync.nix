{ pkgs, ... }:

{
  home.packages = [ pkgs.swaynotificationcenter ];

  # SwayNC auto-starts via XDG autostart (enabled in Hyprland systemd config)
  xdg.configFile."swaync/config.json".text = builtins.toJSON {
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "overlay";
    cssPriority = "application";
    notification-icon-size = 48;
    notification-body-image-height = 100;
    notification-body-image-width = 200;
    timeout = 6;
    timeout-low = 3;
    timeout-critical = 12;
    fit-to-screen = true;
    control-center-width = 380;
    notification-window-width = 380;
    keyboard-shortcuts = true;
    image-visibility = "when-available";
    transition-time = 200;
    hide-on-clear = true;
    hide-on-action = true;
    script-fail-notify = true;
  };
}
