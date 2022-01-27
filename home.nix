{config, pkgs, ...}:
let
  scripts = pkgs.callPackage ./shellScripts { inherit config pkgs; };
  myPackages = with pkgs; [
    pyspread
    font-awesome
    hack-font
  ];
in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home = {
    enableNixpkgsReleaseCheck = true;
    packages = myPackages ++ scripts;
    sessionVariables = {
      EDITOR = "${pkgs.neovim}/bin/nvim";
      VISUAL = "${pkgs.neovim}/bin/nvim";
    };
  };
  xdg.enable = true;
}
