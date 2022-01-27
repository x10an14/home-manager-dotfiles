{config, pkgs, ...}:
let
  systemd-cat = "${pkgs.systemd}/bin/systemd-cat";
  sway = "${pkgs.sway}/bin/sway";
  tmux = "${pkgs.tmux}/bin/tmux";
in {
  programs.bash = {
    enable = true;
    historyControl = [ "ignorespace" ];
    historyFile = "${config.home.homeDirectory}/.bash_history";
    historyFileSize = -1;
    historySize = -1;

    profileExtra = ''
      XDG_PICTURES_DIR="$HOME/Pictures"
      XDG_SCREENSHOTS_DIR="$XDG_PICTURES_DIR"
      export XDG_PICTURES_DIR XDG_SCREENSHOTS_DIR

      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty4" ]; then
             # https://wiki.archlinux.org/title/Sway#Automatically_on_TTY_login
             ${systemd-cat} --identifier=sway ${sway} --debug
      fi
      ${tmux} attach-session
    '';

    bashrcExtra = ''
      # 'alias' for finding git repos
      git_repo() {
        DIRS=(
          "$HOME/nav_github/"
          "$HOME/github/"
          "$HOME/gitlab/"
          "$HOME/sourcehut/"
       )
       cd "$(\
        find "''${DIRS[@]}" \
          -type d \
          -name '.git' \
          -not -path "*asdf/installs/rust/*" \
          -exec dirname {} \; 2>/dev/null |
          fzf --ansi --select-1 --query "$1")" || return
      }


      # 'alias' for generating totp codes
      totp() {
        find "''${PASSWORD_STORE_DIR:-$HOME/.local/share/.passwordstore}/" \
          -type f \
          -wholename '*/2fa/totp.gpg' |
        sed --regexp-extended "s|$pass_dir/(.+).gpg|\1|" |
        fzf --ansi --select-1 --query "$1" |
        print-totp-code.sh
      }

      function remove_segment_from_string() {
        local segment string
        segment="$1"
        string="$2"
        # Taken from: https://unix.stackexchange.com/a/270558/119282
        sed -e "s;\(^\|:\)''${segment%/}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g' <<< "$string"
      }

      function move_path_segment_to_end_of_path() {
        # See: https://github.com/junegunn/fzf/issues/2524
        local segment_search_term
        segment_search_term="$1"

        # Do a for loop in case of multiple search results
        for segment in $(tr ':' '\n' <<< "$PATH" | fzf --filter="$segment_search_term" | sort -u); do
          PATH="$(remove_segment_from_string "$segment" "$PATH")"
          PATH="$PATH:$segment"
        done
        export PATH
      }

      rga-fzf() {
        # https://github.com/phiresky/ripgrep-all#integration-with-fzf
        RG_PREFIX="rga --files-with-matches"
        local file
        file="$(
          FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
            fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
              --phony -q "$1" \
              --bind "change:reload:$RG_PREFIX {q}" \
              --preview-window="70%:wrap"
        )" &&
        echo "opening $file" &&
        xdg-open "$file"
      }
    '';
  };
}
