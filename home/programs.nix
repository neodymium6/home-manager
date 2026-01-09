{ pkgs, lib, isLinux, gitName, gitEmail, ... }:

{
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
        fzf = "fzf --preview='bat --color=always {}'";
      };
      bashrcExtra =
        (lib.optionalString isLinux ''
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
          name = gitName;
          email = gitEmail;
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
