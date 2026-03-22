{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    btop
    ouch
  ];

  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.bat = {
    enable = true;
    # Colors managed by Stylix
    config = {
      style = "numbers,changes,header";
      pager = "less -FR";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };

  programs.fzf = {
    enable = true;
    # Colors managed by Stylix
    enableFishIntegration = false;
    defaultCommand = "fd --type f --hidden --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--border"
      "--inline-info"
    ];
    fileWidgetCommand = "fd --type f --hidden --exclude .git";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    ];
    changeDirWidgetCommand = "fd --type d --hidden --exclude .git";
    changeDirWidgetOptions = [
      "--preview 'eza --tree --level=1 --icons {}'"
    ];
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      auto_sync = false;
      sync_address = "";
      style = "compact";
      show_preview = true;
      inline_height = 20;
      search_mode = "fuzzy";
      filter_mode = "global";
      update_snapshots = true;
    };
  };

  programs.yazi = {
    enable = true;
    # Colors managed by Stylix
    enableFishIntegration = true;
    shellWrapperName = "y";
    settings = {
      manager = {
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
      };
    };
  };

  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
    gitCredentialHelper.enable = true;
  };

  programs.lazygit = {
    enable = true;
    # Colors managed by Stylix
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
