{ pkgs, lib, isLinux, gitName, gitEmail, ... }:

let
  bashFunctions = import ./bash-functions { inherit pkgs; };
in
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
      historySize = 5000;
      historyFileSize = 5000;
      historyControl = [ "ignorespace" "ignoredups" ];
      bashrcExtra =
        (lib.optionalString isLinux ''
          eval "$(${pkgs.coreutils}/bin/dircolors -b)"
        '') + ''
          export PATH="$HOME/.local/bin:$PATH"
          ${bashFunctions}
          [[ $- == *i* ]] && source -- "$(blesh-share)"/ble.sh --attach=none
          eval "$(${pkgs.starship}/bin/starship init bash --print-full-init)"
          eval "$(${pkgs.zoxide}/bin/zoxide init bash --cmd cd)"
          eval "$(${pkgs.direnv}/bin/direnv hook bash)"

          if [[ ''${BLE_VERSION-} ]]; then
            _ble_contrib_fzf_base=${pkgs.fzf}/share/fzf
            ble-import -d integration/fzf-completion
            ble-import -d integration/fzf-key-bindings
          else
            eval "$(${pkgs.fzf}/bin/fzf --bash)"
          fi

          [[ ! ''${BLE_VERSION-} ]] || ble-attach
        '';
    };

    git = {
      enable = true;
      lfs.enable = true;
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
