{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/profiles/headless.nix") ];
  # Make sure that we still have admin access to the machine
  services.openssh.enable = true;
  networking.hostName = "golem";
  networking.firewall.allowedTCPPorts = [ 22 ];
  system.stateVersion = "23.05";
  time.timeZone = "America/Chicago";
  users.users = {
    jmoore = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKm+gtptToHUWVIVd52pDPXcw4oDnno5ZrCkYIv79lUr jesse@jessemoore.dev" ];
    };
  };
  security.sudo.extraRules = [
    {
      users = [ "jmoore" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];
}
