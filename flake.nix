{
  description = "jesse@jessemoore.dev NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    sops-nix.url = "github:Mic92/sops-nix";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-serve-ng = {
    #   url = "github:aristanetworks/nix-serve-ng";
    # };
    comma = {
      url = "github:nix-community/comma";
    };
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    zellij = {
      url = "github:zellij-org/zellij";
      flake = false;
    };

  };
  outputs =
    { nixpkgs
    , home-manager
    , nur
    , sops-nix
    , nixos-generators
    # , nix-serve-ng
    , comma
    , nix-index-database
    # , nix-doom-emacs
    , zellij
    , ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = import ./lib {
        nixpkgs = nixpkgs;
        home-manager = home-manager;
        nur = nur;
        sops-nix = sops-nix;
        # nix-serve-ng = nix-serve-ng;
        nix-index-database = nix-index-database;
        # nix-doom-emacs = nix-doom-emacs;
      };
      personalPackageSet = lib.systemPkgs {
        system = system;
        unfree = [
          "discord"
          "nvidia"
          "nvidia-x11"
          "nvidia-settings"
          "teams"
          "steam"
          "steam-original"
          "steam-run"
          "steam-runtime"
          "steam-unwrapped"
        ];
        overlays = [ nur.overlay ];
      };
      homeModules = lib.getModulePaths personalPackageSet ./home-modules;
      systemModules = lib.getModulePaths personalPackageSet ./system-modules;
      homeConfig = import ./jmoore.nix;
      nixModule = systemModules.nix inputs;
    in
    {
      lib = lib;
      homeModules = homeModules;
      systemModules = systemModules;
      homeConfig = homeConfig;
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      homeManagerConfigurations = lib.createHomeManagerConfigs personalPackageSet {
        "jmoore@asmodeus" = {
          userConfig = homeConfig {
            pkgs = personalPackageSet;
            # doom = nix-doom-emacs;
            zellij = zellij;
            additionalModules = [ homeModules.xmonad ];
          };
          pkgs = personalPackageSet;
        };
        "jmoore@baphomet" = {
          userConfig = homeConfig {
            pkgs = personalPackageSet;
            # doom = nix-doom-emacs;
            zellij = zellij;
            additionalModules = [ homeModules.xmonad ];
          };
          pkgs = personalPackageSet;
        };
      };
      nixosConfigurations = lib.createNixosSystems personalPackageSet {
        asmodeus = {
          hardwareConfig = {
            imports = [
              ./hardware-configs/asmodeus.nix
              #systemModules.amd
              systemModules.lightdm
              nixModule
              systemModules.nix-index
              systemModules.network
              systemModules.nix-serve-ng
              systemModules.nvidia
              systemModules.openssh
              systemModules.openvpn
              systemModules.pci-passthrough
              (systemModules.sops ./secrets/example.yaml)
              systemModules.sound
              systemModules.steam
              systemModules.system-builder
              systemModules.system-packages
              systemModules.tailscale
              systemModules.users
              systemModules.virtualization
              systemModules.xserver
              {networking.firewall.allowedTCPPorts = [ 8080 ];}
            ];
          };
          system = personalPackageSet.system;
          pkgs = personalPackageSet;
        };
        baphomet = {
          hardwareConfig = {
            imports = [
              ./hardware-configs/baphomet.nix
              nixModule
              systemModules.nix-index
              systemModules.network
              systemModules.openssh
              systemModules.openvpn
              systemModules.qemu
              (systemModules.sops ./secrets/example.yaml)
              systemModules.sound
              systemModules.steam
              systemModules.system-packages
              systemModules.system-updater
              systemModules.tailscale
              systemModules.users
              systemModules.virtualization
              systemModules.xfce
              systemModules.xserver
              {networking.firewall.allowedTCPPorts = [ 8000 9339 ];}
            ];
          };
          system = personalPackageSet.system;
          pkgs = personalPackageSet;
        };
      };
      #packages.x86_64-linux.golem = nixos-generators.nixosGenerate {
      #  pkgs = personalPackageSet;
      #  system = personalPackageSet.system;
      #  modules = [
      #    sops-nix.nixosModules.sops
      #    nur.nixosModules.nur
      #    home-manager.nixosModules.home-manager
      #    {
      #      home-manager.useGlobalPkgs = true;
      #      home-manager.users.jmoore = homeConfig {
      #        pkgs = personalPackageSet;
      #      };
      #    }
      #    {
      #      imports = [
      #        ./hardware-configs/golem.nix
      #        nixModule
      #        systemModules.openssh
      #        systemModules.openvpn
      #        (systemModules.sops ./secrets/example.yaml)
      #        systemModules.users
      #        systemModules.virtualization
      #      ];
      #    }
      #  ];
      #  format = "vm";
      #};
      #packages.x86_64-linux.spectre = nixos-generators.nixosGenerate {
      #  pkgs = personalPackageSet;
      #  system = personalPackageSet.system;
      #  modules = [
      #    sops-nix.nixosModules.sops
      #    nur.nixosModules.nur
      #    home-manager.nixosModules.home-manager
      #    {
      #      home-manager.useGlobalPkgs = true;
      #      home-manager.users.jmoore = homeConfig {
      #        pkgs = personalPackageSet;
      #        additionalModules = [ homeModules.xmonad ];
      #      };
      #    }
      #    {
      #      imports = [
      #        ./hardware-configs/spectre.nix
      #        nixModule
      #        (systemModules.sops ./secrets/example.yaml)
      #        systemModules.sound
      #        systemModules.users
      #        systemModules.virtualization
      #      ];
      #    }
      #  ];
      #  format = "iso";
      #};
    };
}
