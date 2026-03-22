{
  description = "ClaudeOS — Ubuntu 24.04 + Hyprland + Nix Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      system-manager,
      treefmt-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      helper = import ./lib { inherit inputs pkgs; };
    in
    {
      # Home Manager configurations — one per host
      homeConfigurations = {
        "tom@gti" = helper.mkHome "gti";
        "tom@transporter" = helper.mkHome "transporter";
      };

      # System Manager configuration — declarative system-level config on Ubuntu
      systemConfigs.default = system-manager.lib.makeSystemConfig {
        extraSpecialArgs = { inherit inputs pkgs; };
        modules = [ ./system-manager ];
      };

      # Formatter
      formatter.${system} =
        (treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
        }).config.build.wrapper;
    };
}
