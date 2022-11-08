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
      lib = import ./lib {
        nixpkgs = nixpkgs;
        home-manager = home-manager;
        nur = nur;
        sops-nix = sops-nix;
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      homeManagerConfigurations = lib.createHomeManagerConfigs (lib.systemPkgs "x86_64-linux") {
        "jmoore@jmoore-nixos" = {
          userConfig = import ./jmoore.nix;
          displayConfig = [
            {
              imports = [ ./home-modules/i3 ];
            }
          ];
          pkgs = lib.systemPkgs "x86_64-linux";
        };
        "jmoore@asmodeus" = {
          userConfig = import ./jmoore.nix;
          displayConfig = [
            {
              imports = [ ./home-modules/i3 ];
            }
          ];
          pkgs = lib.systemPkgs "x86_64-linux";
        };
      };
      nixosConfigurations = lib.createNixosSystems (lib.systemPkgs "x86_64-linux") {
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
          pkgs = lib.systemPkgs "x86_64-linux";
        };
        asmodeus = {
          hardwareConfig = {
            imports = [
              ./hardware-configs/asmodeus.nix
              #./system-modules/amd
              ./system-modules/nix
              ./system-modules/nvidia
              ./system-modules/openssh
              ./system-modules/openvpn
              ./system-modules/pci-passthrough
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
          pkgs = lib.systemPkgs "x86_64-linux";
        };
      };
    };
}
