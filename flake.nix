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
      systemPkgs = system: import nixpkgs {
        system = system;
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

      createHomeManagerConfig =
        { userConfig
        , displayConfig ? [ ]
        , customModules ? [ ]
        , pkgs ? import nixpkgs
        }: home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          modules = [
            { nixpkgs.overlays = [ nur.overlay ]; }
            userConfig
          ] ++ displayConfig ++ customModules;
        };

      createHomeManagerConfigs = pkgs: configs: pkgs.lib.attrsets.mapAttrs
        (name: value: createHomeManagerConfig value)
        configs;

      createNixosSystem =
        { hardwareConfig
        , system
        , pkgs ? import nixpkgs
        }: nixpkgs.lib.nixosSystem {
          system = system;
          pkgs = pkgs;
          modules = [
            sops-nix.nixosModules.sops
            hardwareConfig
          ];
        };

      createNixosSystems = pkgs: configs: pkgs.lib.attrsets.mapAttrs
        (name: value: createNixosSystem value)
        configs;

    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      homeManagerConfigurations = createHomeManagerConfigs (systemPkgs "x86_64-linux") {
        "jmoore@jmoore-nixos" = {
          userConfig = import ./jmoore.nix;
          displayConfig = [
            {
              imports = [ ./home-modules/i3 ];
            }
          ];
          pkgs = systemPkgs "x86_64-linux";
        };
        "jmoore@asmodeus" = {
          userConfig = import ./jmoore.nix;
          displayConfig = [
            {
              imports = [ ./home-modules/i3 ];
            }
          ];
          pkgs = systemPkgs "x86_64-linux";
        };
      };
      nixosConfigurations = createNixosSystems (systemPkgs "x86_64-linux") {
        jmoore-nixos = {
          hardwareConfig = {
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
          system = "x86_64-linux";
          pkgs = systemPkgs "x86_64-linux";
        };
        asmodeus = {
          hardwareConfig = {
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
          system = "x86_64-linux";
          pkgs = systemPkgs "x86_64-linux";
        };
      };
    };
}
