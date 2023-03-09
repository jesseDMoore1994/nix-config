inputs: { config, pkgs, ... }:
{
  nix.settings.substituters = [
    "https://nixcache.reflex-frp.org"
  ];
  nix.settings.trusted-public-keys = [
    "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
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
