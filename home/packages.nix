{ pkgs, lib, isDarwin, withGUI, inputs, ... }:

{
  home.packages = with pkgs; [
    # Shell & Prompt
    blesh
    direnv
    starship
    zoxide

    # Terminal Multiplexer
    tmux
    zellij

    # Music
    inputs.ratune.packages.${pkgs.stdenv.hostPlatform.system}.default

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
    gh
    git-lfs
    lazygit
    python314

    # System & Utilities
    btop
    less
    fastfetch
    unzip
  ] ++ lib.optionals isDarwin [
    firefox
    google-chrome
    nodejs
    slack
    vscode
    wezterm
    colima
    docker
    docker-compose
  ] ++ lib.optionals (!isDarwin) [
    claude-code
    codex
  ] ++ lib.optionals (withGUI && !isDarwin) [
    firefox
    google-chrome
  ];
}
