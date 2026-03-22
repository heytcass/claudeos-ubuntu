{ ... }:

{
  # Hyprlock — lock screen
  # Colors, background, and input-field styling managed by Stylix
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 5;
        hide_cursor = true;
      };
    };
  };
}
