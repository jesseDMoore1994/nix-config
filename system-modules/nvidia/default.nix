pkgs:

{
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ];
  hardware.opengl.enable = true;
  security.rtkit.enable = true;
}
