{ lib, ... }:

let
  themeLib = import ../../lib/theme.nix;
in
{
  programs.ghostty = {
    enable = true;
    # Colors managed by Stylix

    settings = {
      font-family = lib.mkForce [
        themeLib.fonts.monospace.nerdName
        themeLib.fonts.symbols.name
        themeLib.fonts.symbols.fallback
        themeLib.fonts.emoji.name
      ];
      font-size = 11;
      cursor-style = "block";
      cursor-style-blink = false;
      window-padding-x = 8;
      window-padding-y = 8;
      window-decoration = true;
      gtk-titlebar = true;
      linux-cgroup = "always";
      shell-integration = "fish";
      shell-integration-features = "cursor,sudo,title";
      scrollback-limit = 50000;
      copy-on-select = true;
      mouse-hide-while-typing = true;
      window-save-state = "always";
      window-inherit-working-directory = true;
      window-inherit-font-size = true;
      quit-after-last-window-closed = true;
      confirm-close-surface = false;
    };
  };
}
