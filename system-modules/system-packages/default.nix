{ config, pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [ 24800 ];

}
