pkgs:

{
  programs.steam = {
    enable = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [
      { from = 27015; to = 27050; }
    ];
    allowedTCPPortRanges = [
      { from = 27015; to = 27050; }
    ];
  };
}
