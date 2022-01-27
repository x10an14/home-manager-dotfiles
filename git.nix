{config, ...}:
{
  programs.git = {
    enable = true;
    userEmail = "x10an14@users.noreply.github.com";
    userName = "x10an14";
    signing = {
      signByDefault = true;
      key = "40342E76F04C8890A58CB9FA3F2FC44B567B28FA";
    };
    includes = [
      {
        path = "~/.config/git/config.nav";
        condition = "gitdir:**/nav/**";
      }
      {
        path = "~/.config/git/config.nav";
        condition = "gitdir:**/navikt/**";
      }
      {
        path = "~/.config/git/config.nav";
        condition = "gitdir:**/nais/**";
      }
      {
        path = "~/.config/git/config.nav";
        condition = "gitdir:**/nav_github/**";
      }
    ];
  };
}
