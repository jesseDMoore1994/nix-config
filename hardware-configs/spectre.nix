{ config, lib, pkgs, modulesPath, ... }: {
  #imports = [
  #  "${modulesPath}/installer/netboot/netboot.nix"
  #];

  # use the latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

  # Make sure that we still have admin access to the machine
  networking.hostName = "spectre";
  system.stateVersion = "23.05";
  time.timeZone = "America/Chicago";
  users.users = {
    jmoore = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "jmoore";
      # Use a fake session. The actual session is managed by Home Manager.
      defaultSession = "none+fake";
      session = [{ manage = "window"; name = "fake"; start = ""; }];
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
