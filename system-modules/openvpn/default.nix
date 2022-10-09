{config, pkgs, ... }:
{
  services.openvpn.servers = {
    pia = {
      autoStart = false;
      config = "config /run/secrets/pia-config";
    };
  };
}
