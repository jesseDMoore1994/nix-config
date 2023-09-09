pkgs: { 
  zellij ? null
  , ...
}: 
{
  home.file.".config/zellij/themes" = {
    recursive = true;
    source = "${zellij}/zellij-utils/assets/themes";
  };

  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
    settings = {
      theme = "dracula";
    };
  };

}
