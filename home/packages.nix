{ pkgs, lib, isDarwin, ... }:

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
    git-lfs
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
}
