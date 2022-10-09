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

    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      # allow teams even though it isn't free software
      config.allowUnfreePredicate = (pkg:
        builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) [
          "teams"
        ]
      );
    };

    lib = nixpkgs.lib;

    homeManagerBaseConfig = {
      imports = [ 
        ./home-modules/bat
        ./home-modules/exa
        ./home-modules/fd
        ./home-modules/firefox
        ./home-modules/fonts
        #./home-modules/gnupg
        ./home-modules/kitty
        ./home-modules/neovim
        ./home-modules/starship
        ./home-modules/tmux
        ./home-modules/zoxide
        ./home-modules/zsh
      ];
      home = {
        username = "jmoore";
        homeDirectory = "/home/jmoore";
        packages = with pkgs; [
          git
          jq
          openconnect
          python3
          teams
          wget
        ];
        stateVersion = "21.11";
      };
      programs.home-manager.enable = true;
    };

    homeManagerLaptopConfig = {
      imports = [ 
        ./home-modules/i3
      ];
    };

    jmooreNixosSystemConfig = {
      imports = [
        ./hardware-configs/jmoore-nixos.nix
        ./system-modules/nix
        ./system-modules/openssh
        ./system-modules/sops
        ./system-modules/openvpn
        ./system-modules/users
        ./system-modules/virtualization
        ./system-modules/xserver
      ];
    
      boot.loader.grub.enable = true;
      boot.loader.grub.version = 2;
      boot.loader.grub.device = "/dev/sda";
      networking.hostName = "jmoore-nixos";
      time.timeZone = "America/Chicago";
      networking.useDHCP = false;
      networking.interfaces.ens3.useDHCP = true;
      system.stateVersion = "21.11";
    };

  in {
    homeManagerConfigurations = {
      "jmoore@jmoore-nixos" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          { nixpkgs.overlays = [ nur.overlay ];}
          homeManagerBaseConfig
          homeManagerLaptopConfig
        ];
      };
    };
    nixosConfigurations = {
      jmoore-nixos = lib.nixosSystem {
        inherit system;
	modules = [
          sops-nix.nixosModules.sops
          jmooreNixosSystemConfig
	];
      };
    };
  };
}
