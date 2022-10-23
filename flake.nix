{
  description = "jesse@jessemoore.dev NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";
  };
  outputs = { nixpkgs, home-manager, nur, sops-nix, ... }:
  let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = (pkg:
        builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) [
          "nvidia"
          "nvidia-x11"
          "nvidia-settings"
          "teams"
          "steam"
          "steam-original"
          "steam-run"
          "steam-runtime"
        ]
      );
    };
    system = "x86_64-linux";

    createHomeManagerConfig = { userConfig, displayConfig ? [], customModules ? [] }: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        { nixpkgs.overlays = [ nur.overlay ];}
        userConfig
      ] ++ displayConfig ++ customModules;
    };

    createNixosSystem = hardwareConfig : nixpkgs.lib.nixosSystem {
      inherit system;
      inherit pkgs;
      modules = [
        sops-nix.nixosModules.sops
        hardwareConfig
      ];
    };

  in {
    homeManagerConfigurations = {
      "jmoore@jmoore-nixos" = createHomeManagerConfig {
        userConfig = import ./jmoore.nix;
        displayConfig = [
          {
            imports = [ ./home-modules/i3];
          }
        ];
      };
      "jmoore@asmodeus" = createHomeManagerConfig {
        userConfig = import ./jmoore.nix;
        displayConfig = [
          {
            imports = [ ./home-modules/i3];
          }
        ];
      };
    };
    nixosConfigurations = {
      jmoore-nixos = createNixosSystem {
        imports = [
          ./hardware-configs/jmoore-nixos.nix
          ./system-modules/nix
          ./system-modules/openssh
          ./system-modules/openvpn
          ./system-modules/sops
          ./system-modules/tailscale
          ./system-modules/users
          ./system-modules/virtualization
          ./system-modules/xserver
        ];
      };
      asmodeus = createNixosSystem {
        imports = [
          ./hardware-configs/asmodeus.nix
          ./system-modules/nix
          ./system-modules/nvidia
          ./system-modules/openssh
          ./system-modules/openvpn
          ./system-modules/sops
          ./system-modules/sound
          ./system-modules/steam
          ./system-modules/tailscale
          ./system-modules/users
          ./system-modules/virtualization
          ./system-modules/xserver
        ];
      };
    };
  };
}
