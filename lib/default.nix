{ nixpkgs, home-manager, nur, sops-nix, nix-serve-ng, ... }:

rec {
  systemPkgs =
    { system
    , unfree
    , overlays ? [ ]
    }: import nixpkgs {
      system = system;
      overlays = overlays;
      config.allowUnfreePredicate = (pkg:
        builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) unfree
      );
    };

  createHomeManagerConfig =
    { userConfig, pkgs }: home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      modules = [
        userConfig
      ];
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
        nix-serve-ng.nixosModules.default
        sops-nix.nixosModules.sops
        hardwareConfig
      ];
    };

  createNixosSystems = pkgs: configs: pkgs.lib.attrsets.mapAttrs
    (name: value: createNixosSystem value)
    configs;

  getModulePaths = pkgs: modules: pkgs.lib.attrsets.mapAttrs
    (name: value: import (builtins.head value))
    (pkgs.lib.attrsets.zipAttrs (map (n: {"${n}"= "${modules}/${n}";}) (builtins.attrNames (builtins.readDir modules))));
}
