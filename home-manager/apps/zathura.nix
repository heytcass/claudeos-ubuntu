{ ... }:

{
  programs.zathura = {
    enable = true;
    # Colors managed by Stylix

    options = {
      selection-clipboard = "clipboard";
      recolor = true;
      guioptions = "s";
      incremental-search = true;
      window-title-basename = true;
      scroll-step = 80;
      scroll-page-aware = true;
      statusbar-h-padding = 8;
      statusbar-v-padding = 4;
      page-padding = 4;
    };

    mappings = {
      "<Left>" = "scroll left";
      "<Right>" = "scroll right";
      "<Up>" = "scroll up";
      "<Down>" = "scroll down";
      "<Space>" = "scroll full-down";
      "<S-Space>" = "scroll full-up";
      "<C-d>" = "scroll half-down";
      "<C-u>" = "scroll half-up";
      "=" = "zoom in";
      "-" = "zoom out";
      "0" = "zoom reset";
      "w" = "adjust_window width";
      "b" = "adjust_window best-fit";
      "<Home>" = "goto 1";
      "<End>" = "goto -1";
      "/" = "search forward";
      "?" = "search backward";
      "n" = "search forward";
      "N" = "search backward";
      "r" = "rotate";
      "p" = "print";
      "i" = "recolor";
      "d" = "toggle_page_mode";
      "f" = "toggle_fullscreen";
      "t" = "toggle_index";
      "<C-r>" = "reload";
      "q" = "quit";
    };
  };
}
