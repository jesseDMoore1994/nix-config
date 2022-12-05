{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      darkreader
      firefox-color
      ublock-origin
      umatrix
      vimium
    ];
    profiles.default = {
      id = 0;
      name = "Default";
      isDefault = true;
    };
  };
}
