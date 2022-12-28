# put this file in /etc/nixos/
# change the settings tagged with "CHANGE:"
# and add 
#   ./pci-passthrough.nix
# to /etc/nixos/configuration.nix in `imports`

{ config, pkgs, ... }:
{
  # CHANGE: intel_iommu enables iommu for intel CPUs with VT-d
  # use amd_iommu if you have an AMD CPU with AMD-Vi
  boot.kernelParams = [ "amd_iommu=on" ];
  boot.blacklistedKernelModules = [ "amdgpu" ];

  # These modules are required for PCI passthrough, and must come before early modesetting stuff
  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

  # CHANGE: Don't forget to put your own PCI IDs here
  boot.extraModprobeConfig = ''
    options vfio-pci ids=1002:73df,1002:ab28
    softdep amdgpu pre: vfio-pci
  '';

  environment.systemPackages = with pkgs; [
    virtmanager
    qemu
    OVMF
  ];

  virtualisation.libvirtd.enable = true;

  # CHANGE: add your own user here
  users.groups.libvirtd.members = [ "root" "jmoore" ];

  networking.firewall.checkReversePath = false;

  virtualisation.libvirtd.qemu.swtpm.enable = true;

  # to find your nix store paths
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
    cgroup_device_acl = [
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet",
        "/dev/input/by-id/usb-Corsair_Corsair_Gaming_K55_RGB_Keyboard_AF6510E85DF81A35F5001C0540048000-event-kbd",
        "/dev/input/by-id/usb-Razer_Razer_Basilisk_V3-event-mouse"
    ]
    user = "root"
    group = "root"
  '';

}
