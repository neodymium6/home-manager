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
      "zoom"
    ];
    masApps = {
      "Yoink" = 457622435;
    };
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
  };
}
