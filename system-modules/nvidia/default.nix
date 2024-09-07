pkgs:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.open = false;
  security.rtkit.enable = true;
}
