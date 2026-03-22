{ ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/Projects/claudeos/assets/wallpaper.jpg" ];
      wallpaper = [ ",~/Projects/claudeos/assets/wallpaper.jpg" ];
      splash = false;
    };
  };
}
