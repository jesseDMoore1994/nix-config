{ nixpkgs, home-manager, nur, sops-nix, ... }:

rec {
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
}
