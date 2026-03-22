# Dell XPS 13 9370 — host-specific overrides
{ ... }:

{
  # Display scaling for 13" 1080p
  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1, preferred, auto, 1.25"
    ", preferred, auto, 1.0"
  ];
}
