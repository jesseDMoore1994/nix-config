{ config, pkgs, ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 5000 ];
  };
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/run/secrets/cache-priv-key.pem";
  };
  nix.settings."secret-key-files" = "/run/secrets/cache-priv-key.pem";
}
