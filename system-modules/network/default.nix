{ config, pkgs, ... }:
{
  systemd.services.NetworkManager-wait-online.enable = false;
}
