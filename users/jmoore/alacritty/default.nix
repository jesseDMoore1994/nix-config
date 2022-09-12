pkgs:

{
  enable = true;
  settings = {


    window = {
      opacity = 0.0;
      padding.x = 10;
      padding.y = 10;
      decorations = "none";
    };

    font = {
      size = 11.0;
      use-thin-strokes = true;

       normal.family = "Hasklug Nerd Font";
       bold.family = "Hasklug Nerd Font";
       italic.family = "Hasklug Nerd Font";
    };

    # Colors (Dracula)
    colors = {
      # Default colors
      primary = {
        background = "#282a36";
        foreground = "#f8f8f2";
      };
      # Normal colors
      normal = {
        black =  "#000000";
        red =    "#ff5555";
        green =  "#50fa7b";
        yellow = "#f1fa8c";
        blue =   "#caa9fa";
        magenta ="#ff79c6";
        cyan =   "#8be9fd";
        white =  "#bfbfbf";
      };
    
      # Bright colors
      bright = {
        black =  "#575b70";
        red =    "#ff6e67";
        green =  "#5af78e";
        yellow = "#f4f99d";
        blue =   "#caa9fa";
        magenta ="#ff92d0";
        cyan =   "#9aedfe";
        white =  "#e6e6e6";
      };
    };
  };
}
