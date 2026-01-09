{ pkgs, username, ... }:

{
  imports = [
    ./modules/system.nix
    ./modules/homebrew.nix
    ./modules/fonts.nix
    ./modules/applications.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = 6;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.bashInteractive;
  };

  system.primaryUser = username;

  environment.shells = with pkgs; [ bashInteractive ];

  environment.systemPackages = with pkgs; [
    git
  ];
}

