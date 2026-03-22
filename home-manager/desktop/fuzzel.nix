{ ... }:

{
  programs.fuzzel = {
    enable = true;
    # Colors managed by Stylix
    settings = {
      main = {
        prompt = "\"❯  \"";
        layer = "overlay";
        lines = 8;
        width = 35;
        horizontal-pad = 16;
        vertical-pad = 10;
        inner-pad = 8;
      };
      border = {
        width = 2;
        radius = 12;
      };
    };
  };
}
