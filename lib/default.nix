{ inputs, pkgs, ... }:

{
  mkHome =
    hostname:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
      };
      modules = [
        inputs.stylix.homeManagerModules.stylix
        ../home-manager
        ../hosts/${hostname}.nix
      ];
    };
}
