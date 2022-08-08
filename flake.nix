{
  description = "jesse@jessemoore.dev NixOS configuration flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
    lib = nixpkgs.lib;
  in {
    homeManagerConfigurations = {
      jmoore = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
	  ./users/jmoore/home.nix
	];
      };
    };
    nixosConfigurations = {
      jmoore-nixos = lib.nixosSystem {
        inherit system;
	modules = [
          ./nixos/jmoore-nixos/configuration.nix
	];
      };
    };
  };
}
