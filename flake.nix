{
  description = "Home Manager configuration of neodymium6";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvchad-starter = {
      url = "github:neodymium6/nvchad";
      flake = false;
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nvchad-starter.follows = "nvchad-starter";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ nixpkgs, home-manager, nix-darwin, nix4nvchad, nix-homebrew, ... }:
    let
      username = "neodymium6";

      # Linux-specific unfree packages
      linuxNixpkgsConfig = {
        allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "claude-code"
          ];
      };

      # macOS-specific unfree packages
      darwinNixpkgsConfig = {
        allowUnfreePredicate = pkg:
          builtins.elem (nixpkgs.lib.getName pkg) [
            "claude-code"
            "google-chrome"
            "slack"
          ];
      };

      # Debian
      linuxSystem = "x86_64-linux";

      # macOS (M5/arm)
      darwinSystem = "aarch64-darwin";
      darwinHost = "mpb-2025-m5";
    in
    {
      # -----------------------
      # Linux: home-manager standalone
      # -----------------------
      homeConfigurations."${username}" =
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = linuxSystem;
            config = linuxNixpkgsConfig;
          };
          modules = [
            ./home.nix
            nix4nvchad.homeManagerModule
          ];
        };

      # -----------------------
      # macOS: nix-darwin + home-manager
      # -----------------------
      darwinConfigurations.${darwinHost} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;

        specialArgs = { inherit username; };

        modules = [
          ./darwin/configuration.nix

          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              user = username;
            };
          }

          home-manager.darwinModules.home-manager
          {
            nixpkgs.config = darwinNixpkgsConfig;

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${username} = {
              imports = [
                ./home.nix
                nix4nvchad.homeManagerModule
              ];
            };
          }
        ];
      };
    };
}
