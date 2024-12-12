inputs: { config, pkgs, ... }:
{
  nix.settings.trusted-users = [
    "jmoore"
  ];
  nix.settings.trusted-substituters = [
    "http://asmodeus:5000"
  ];
  nix.settings.substituters = [
    "http://asmodeus:5000"
  ];
  nix.settings.trusted-public-keys = [
    "asmodeus:WKrosLhHuvmGH3WdbWrpj7YcForjEtz7rOsXzU88H9o="
  ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
  nix.package = pkgs.nixVersions.stable;
}
