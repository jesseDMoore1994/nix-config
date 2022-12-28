{
  description = "jesse@jessemoore.dev NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, nur, sops-nix, nixos-generators, ... }:
    let
      lib = import ./lib {
        nixpkgs = nixpkgs;
        home-manager = home-manager;
        nur = nur;
        sops-nix = sops-nix;
      };
      personalPackageSet = lib.systemPkgs {
        system = "x86_64-linux"; 
        overlays = [ nur.overlay ];
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      homeManagerConfigurations = lib.createHomeManagerConfigs personalPackageSet {
        "jmoore@jmoore-nixos" = {
          userConfig = import ./jmoore.nix;
          displayConfig = [
            {
              imports = [ ./home-modules/i3 ];
            }
          ];
          pkgs = personalPackageSet;
        };
        "jmoore@asmodeus" = {
          userConfig = import ./jmoore.nix;
          displayConfig = [
            {
              imports = [ ./home-modules/xmonad ];
            }
          ];
          pkgs = personalPackageSet;
        };
      };
      nixosConfigurations = lib.createNixosSystems personalPackageSet {
        jmoore-nixos = {
          hardwareConfig = {
            imports = [
              ./hardware-configs/jmoore-nixos.nix
              ./system-modules/lightdm
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
          system = personalPackageSet.system;
          pkgs = personalPackageSet;
        };
        asmodeus = {
          hardwareConfig = {
            imports = [
              ./hardware-configs/asmodeus.nix
              #./system-modules/flatpak
              ./system-modules/lightdm
              ./system-modules/nix
              ./system-modules/nvidia
              ./system-modules/openssh
              ./system-modules/openvpn
              ./system-modules/pci-passthrough
              ./system-modules/sops
              ./system-modules/sound
              ./system-modules/steam
              #./system-modules/tailscale
              ./system-modules/users
              ./system-modules/virtualization
              ./system-modules/xserver
            ];
          };
          system = personalPackageSet.system;
          pkgs = personalPackageSet;
        };
      };
      packages.x86_64-linux.vm = nixos-generators.nixosGenerate {
        pkgs = personalPackageSet;
        system = personalPackageSet.system;
        modules = [
          sops-nix.nixosModules.sops
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.jmoore = import ./jmoore.nix;
          }
          {
            imports = [
              ./hardware-configs/headless-vm.nix
              ./system-modules/nix
              ./system-modules/openssh
              ./system-modules/openvpn
              ./system-modules/sops
              ./system-modules/users
              ./system-modules/virtualization
            ];
          }
        ];
        format = "vm";
      };
    };
}
