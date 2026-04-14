{ ... }:

{
  homebrew = {
    enable = true;
    casks = [
      "hammerspoon"
      "karabiner-elements"
      "amethyst"
      "linearmouse"
      "logi-options+"
      "raycast"
      "tailscale-app"
      "zoom"
      "easydict"
      "claude-code"
      "codex"
      "zotero"
      "notion"
    ];
    masApps = {
      "Yoink" = 457622435;
      "WireGuard" = 1451685025;
    };
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
  };
}
