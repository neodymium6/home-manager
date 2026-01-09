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

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Common packages (Linux & macOS)
    neofetch
    less
    bat
    eza
    blesh
    ripgrep
    lazygit
    unzip
    python314
    cargo
    tree
    claude-code
    btop
    yazi
    dust
    fd
    delta
    zellij
    zoxide
    direnv
    tmux
    starship
    fzf
  ] ++ lib.optionals isDarwin [
    # macOS-specific packages
    wezterm
    firefox
    google-chrome
    slack
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/neodymium6/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
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
