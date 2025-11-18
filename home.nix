{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "neodymium6";

  home.homeDirectory = "/home/neodymium6";

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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
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

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/tmux/scripts/shorten_path.sh" = {
      source = ./config/tmux/scripts/shorten_path.sh;
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
      bashrcExtra = ''
        eval "$(dircolors -b)"
        [[ $- == *i* ]] && source -- "$(blesh-share)"/ble.sh --attach=none
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
    tmux = {
      enable = true;
      extraConfig = builtins.readFile ./config/tmux/tmux.conf;
    };
    fzf = { enable = true; };
    starship = {
      enable = true;
      enableBashIntegration = true;

      settings =
        builtins.fromTOML (builtins.readFile ./config/starship/config.toml);
    };

    nvchad = {
      enable = true;
      backup = false;
    };
  };
}
