# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/58f8a749-8df9-4cd4-9f71-8bde27460483";
      fsType = "ext4";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/ff681ba1-292a-40a0-bb83-6d71e5ee20dc";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/B980-E7D4";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/462c2be2-b8b3-4703-8d52-899930bdc5bd"; }];

  networking.useDHCP = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "baphomet"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";
  users.users.jmoore = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
  services.openssh.enable = true;
  system.stateVersion = "22.11"; # Did you read the comment?
}

