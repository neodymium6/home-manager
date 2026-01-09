{ config, pkgs, lib, username, ... }:

let
  hmPkgs = config.home-manager.users.${username}.home.packages or [];

  nixAppsEnv = pkgs.buildEnv {
    name = "nix-applications";
    paths = config.environment.systemPackages ++ hmPkgs;
    pathsToLink = [ "/Applications" ];
  };
in
{
  system.activationScripts.applications.text = lib.mkAfter ''
    echo "Setting up /Applications/Nix Spotlight Apps (Finder aliases)..." >&2
    rm -rf /Applications/Nix\ Spotlight\ Apps
    mkdir -p /Applications/Nix\ Spotlight\ Apps

    if [ -d "${nixAppsEnv}/Applications" ]; then
      find "${nixAppsEnv}/Applications" -maxdepth 1 -type l -print0 | \
        while IFS= read -r -d "" link; do
          src="$(/usr/bin/stat -f%Y "$link")"
          dst="/Applications/Nix Spotlight Apps/$(/usr/bin/basename "$src")"
          echo "alias: $dst -> $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "$dst"
        done
    fi
  '';

  launchd.user.agents.hammerspoon = {
    serviceConfig = {
      ProgramArguments = [ "/usr/bin/open" "-a" "Hammerspoon" ];
      RunAtLoad = true;
      KeepAlive = false;
      StandardOutPath = "/tmp/hammerspoon.launchd.out";
      StandardErrorPath = "/tmp/hammerspoon.launchd.err";
    };
  };
}
