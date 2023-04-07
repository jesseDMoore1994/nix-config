pkgs:

{
  home.file.".config/starship.toml".source = ./starship.toml;
  programs.starship = {
    enable = true;
    enableNushellIntegration = false; #temp for nu 0.78 https://github.com/starship/starship/issues/5063
  };
}
