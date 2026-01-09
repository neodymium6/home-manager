{ config, pkgs, lib, ... }:

let
  username = "neodymium6";
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.username = username;

  home.homeDirectory =
    if isDarwin then "/Users/${username}" else "/home/${username}";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # Shell & Prompt
    blesh
    direnv
    starship
    zoxide

    # Terminal Multiplexer
    tmux
    zellij

    # File Management
    bat
    dust
    eza
    fd
    tree
    yazi

    # Search Tools
    fzf
    ripgrep

    # Development
    cargo
    delta
    lazygit
    python314

    # System & Utilities
    btop
    claude-code
    less
    neofetch
    unzip
  ] ++ lib.optionals isDarwin [
    firefox
    google-chrome
    slack
    wezterm
  ];

  home.file = {
    # Common dotfiles (Linux & macOS)
    ".config/tmux/tmux.conf" = {
      source = ./config/tmux/tmux.conf;
    };
    ".config/tmux/scripts/shorten_path.sh" = {
      source = ./config/tmux/scripts/shorten_path.sh;
      executable = true;
    };
    ".config/starship.toml" = {
      source = ./config/starship/config.toml;
    };
  } // lib.optionalAttrs isDarwin {
    # macOS-specific dotfiles
    ".hammerspoon/init.lua" = {
      source = ./config/hammerspoon/init.lua;
    };
    ".config/wezterm/wezterm.lua" = {
      source = ./config/wezterm/wezterm.lua;
    };
    ".config/karabiner/karabiner.json" = {
      source = ./config/karabiner/karabiner.json;
      force = true;
    };
    ".config/amethyst/amethyst.yml" = {
      source = ./config/amethyst/amethyst.yml;
    };
    ".config/linearmouse/linearmouse.json" = {
      source = ./config/linearmouse/linearmouse.json;
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
      source = ./config/raycast/script-commands/open-chrome-new-window.sh;
      executable = true;
    };
  };
  home.activation.installTpm = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
      $DRY_RUN_CMD mkdir -p "$HOME/.config/tmux/plugins"
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
    fi
  '';

  home.sessionVariables = { EDITOR = "nvim"; };

  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ls = "eza -lh --icons";
        la = "eza -lha --icons";
        ll = "eza -lh --icons";
        grep = "grep --color=auto";
      };
      bashrcExtra =
        (lib.optionalString isLinux ''
          # dircolors (Linux only)
          eval "$(${pkgs.coreutils}/bin/dircolors -b)"
        '') + ''
          export PATH="$HOME/.local/bin:$PATH"
          [[ $- == *i* ]] && source -- "$(blesh-share)"/ble.sh --attach=none
          eval "$(${pkgs.starship}/bin/starship init bash --print-full-init)"
          eval "$(${pkgs.zoxide}/bin/zoxide init bash --cmd cd)"
          eval "$(${pkgs.direnv}/bin/direnv hook bash)"
          [[ ! ''${BLE_VERSION-} ]] || ble-attach
        '';
    };
    git = {
      enable = true;
      settings = {
        user = {
          name = "neodymium6";
          email = "104201402+neodymium6@users.noreply.github.com";
        };
        push = { autoSetupRemote = true; };
        init = { defaultBranch = "main"; };
      };
    };

    nvchad = {
      enable = true;
      backup = false;
    };
  };
}
