{ config, pkgs, lib, isDarwin, ... }:

{
  home.file = {
    ".config/tmux/tmux.conf" = {
      source = ../config/tmux/tmux.conf;
    };
    ".config/tmux/scripts/shorten_path.sh" = {
      source = ../config/tmux/scripts/shorten_path.sh;
      executable = true;
    };
    ".config/starship.toml" = {
      source = ../config/starship/config.toml;
    };
  } // lib.optionalAttrs isDarwin {
    ".hammerspoon/init.lua" = {
      source = ../config/hammerspoon/init.lua;
    };
    ".config/wezterm/wezterm.lua" = {
      source = ../config/wezterm/wezterm.lua;
    };
    ".config/karabiner/karabiner.json" = {
      source = ../config/karabiner/karabiner.json;
      force = true;
    };
    ".config/amethyst/amethyst.yml" = {
      source = ../config/amethyst/amethyst.yml;
    };
    ".config/linearmouse/linearmouse.json" = {
      source = ../config/linearmouse/linearmouse.json;
      force = true;
    };
    ".local/bin/stty" = {
      text = ''
        #!/bin/bash
        SELF_DIR="$(cd "$(dirname "$0")" && pwd)"
        REAL_STTY=$(PATH="''${PATH//''${SELF_DIR}:/}" which stty)
        if [[ -n "$NVIM" || -n "$DIRENV_DIR" ]]; then
          "$REAL_STTY" "$@" 2>/dev/null
        else
          exec "$REAL_STTY" "$@"
        fi
      '';
      executable = true;
    };
    ".config/raycast/script-commands/open-chrome-new-window.sh" = {
      source = ../config/raycast/script-commands/open-chrome-new-window.sh;
      executable = true;
    };
    ".config/raycast/script-commands/ask-chatgpt.sh" = {
      source = ../config/raycast/script-commands/ask-chatgpt.sh;
      executable = true;
    };
  };

  home.activation.installTpm = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.config/tmux/plugins"
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
    fi
  '';
}
