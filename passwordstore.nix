{config, pkgs, ...}:
{
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (e: [
      e.pass-audit
      e.pass-otp
      e.pass-genphrase
      e.pass-update
    ]);
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.local/share/passwordstore";
      PASSWORD_STORE_GENERATED_LENGTH = "32";
    };
  };
}
