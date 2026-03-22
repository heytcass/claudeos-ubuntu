# System-level font installation via system-manager
{ pkgs, ... }:

{
  environment.etc = {
    "fonts/fonts.conf".text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
        <dir>/run/current-system/sw/share/fonts</dir>
        <dir>~/.nix-profile/share/fonts</dir>
        <dir>~/.local/share/fonts</dir>
      </fontconfig>
    '';
  };
}
