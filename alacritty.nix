{config, ...}:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "hack";
          style = "Regular";
        };
        bold = {
          family = "hack";
          style = "Bold";
        };
        italic = {
          family = "hack";
          style = "Italic";
        };
        bold_italic = {
          family = "hack";
          style = "Bold Italic";
        };
        #bold_italic = {};
      };
    };
  };
}
