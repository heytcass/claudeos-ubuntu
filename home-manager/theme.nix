{ pkgs, lib, ... }:

let
  themeLib = import ../lib/theme.nix;
in
{
  # Stylix theming with Claude brand colors — same base16 scheme as NixOS ClaudeOS
  stylix = {
    enable = true;

    # Base16 "Claude" — derived from claude.ai dark UI CSS tokens
    base16Scheme = {
      base00 = "141413"; # bg-300: deepest rendered bg
      base01 = "1f1e1d"; # bg-200: hover states, secondary surfaces
      base02 = "262624"; # bg-100: main app bg, sidebar
      base03 = "30302e"; # bg-000: elevated surfaces, line numbers
      base04 = "9c9a92"; # text-400: muted/placeholder text
      base05 = "c2c0b6"; # text-200: secondary body text
      base06 = "dedcd1"; # border-300: warm-stone border color
      base07 = "faf9f5"; # text-000: primary text / inverted bg
      base08 = "e66565"; # Red — variables, deletion, errors
      base09 = "ec845b"; # Orange — integers, booleans, constants
      base0A = "db9200"; # Yellow — classes, warnings, attributes
      base0B = "1cb07c"; # Green — strings, success, additions
      base0C = "74abe2"; # Cyan — escape chars, regex, support
      base0D = "d97757"; # THE accent — functions, headings, links
      base0E = "9b87f5"; # Magenta — keywords, storage, pro accent
      base0F = "e46292"; # Pink — deprecated, special, embedded
    };

    # Wallpaper
    image = ../assets/wallpaper.jpg;
    imageScalingMode = "fill";

    polarity = "dark";

    cursor = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 20;
    };

    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = themeLib.fonts.serif.name;
      };
      sansSerif = {
        package = pkgs.inter;
        name = themeLib.fonts.sansSerif.name;
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = themeLib.fonts.monospace.nerdName;
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = themeLib.fonts.emoji.name;
      };
    };

    # Enable Stylix targets for all themed apps
    targets = {
      gtk.enable = true;
      ghostty.enable = true;
      vscode.enable = true;
      fzf.enable = true;
      bat.enable = true;
      lazygit.enable = true;
      fuzzel.enable = true;
      hyprland.enable = true;
      hyprlock.enable = true;
      hyprpaper.enable = lib.mkForce false; # We manage wallpaper via hyprpaper service
      waybar.enable = true;
    };
  };

  # Qt theming
  qt = {
    enable = true;
    platformTheme.name = lib.mkForce "gtk2";
    style.name = lib.mkForce "adwaita-dark";
  };

  # GTK
  gtk = {
    enable = true;
    iconTheme = {
      name = themeLib.icons.name;
      package = pkgs.adwaita-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  # Force overwrite Stylix-managed GTK CSS
  xdg.configFile = {
    "gtk-3.0/gtk.css".force = true;
    "gtk-4.0/gtk.css".force = true;
  };

  # dconf dark mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      icon-theme = themeLib.icons.name;
    };
  };
}
