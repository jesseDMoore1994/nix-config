pkgs:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  security.rtkit.enable = true;
}
