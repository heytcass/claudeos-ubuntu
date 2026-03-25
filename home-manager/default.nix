{ pkgs, lib, ... }:

{
  imports = [
    ./shell
    ./desktop
    ./apps/ghostty.nix
    ./apps/vscode.nix
    ./apps/zathura.nix
    ./git.nix
    ./theme.nix
    ./monitor.nix
  ];

  home = {
    stateVersion = "24.11";
    username = "tom";
    homeDirectory = "/home/tom";

    sessionVariables = {
      EDITOR = "code";
      VISUAL = "code";
    };
  };

  # XDG user directories
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "/home/tom/Desktop";
    documents = "/home/tom/Documents";
    download = "/home/tom/Downloads";
    music = "/home/tom/Music";
    pictures = "/home/tom/Pictures";
    publicShare = "/home/tom/Public";
    templates = "/home/tom/Templates";
    videos = "/home/tom/Videos";
    extraConfig = {
      PROJECTS = "/home/tom/Projects";
    };
  };

  # Default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "inode/directory" = "nautilus.desktop";
    };
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
