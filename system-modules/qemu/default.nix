# put this file in /etc/nixos/
# change the settings tagged with "CHANGE:"
# and add 
#   ./pci-passthrough.nix
# to /etc/nixos/configuration.nix in `imports`

{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    virt-manager
    qemu
    OVMF
  ];

  virtualisation.libvirtd.enable = true;

  # CHANGE: add your own user here
  users.groups.libvirtd.members = [ "root" "jmoore" ];

  #networking.firewall.checkReversePath = false;

  virtualisation.libvirtd.qemu.swtpm.enable = true;


}
