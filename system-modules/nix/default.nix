inputs: { config, pkgs, ... }:
{
  nix.settings.trusted-substituters = [
    "http://asmodeus:8080/jmoore"
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
  nix.package = pkgs.nixFlakes;
}
