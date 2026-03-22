# system-manager — declarative system-level config on Ubuntu
# Manages: fonts, greetd, and other system services
{ pkgs, ... }:

{
  imports = [
    ./fonts.nix
  ];
}
