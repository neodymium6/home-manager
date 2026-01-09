{ config, pkgs, lib, ... }:

let
  username = "neodymium6";
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  imports = [
    ./home/packages.nix
    ./home/dotfiles.nix
    ./home/programs.nix
  ];

  home.username = username;

  home.homeDirectory =
    if isDarwin then "/Users/${username}" else "/home/${username}";

  home.stateVersion = "25.05";

  home.sessionVariables = { EDITOR = "nvim"; };

  _module.args = { inherit isDarwin isLinux; };
}
