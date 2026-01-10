{ username, ... }:

{
  system.defaults.dock = {
    autohide = true;
    show-recents = false;
    tilesize = 40;
    mineffect = "scale";
    persistent-apps = [
      { app = "/System/Applications/Mail.app"; }
      { app = "/System/Applications/System Settings.app"; }
    ];
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    ShowStatusBar = true;
    ShowPathbar = true;
    _FXShowPosixPathInTitle = true;
    FXEnableExtensionChangeWarning = false;

    ShowHardDrivesOnDesktop = false;
    ShowExternalHardDrivesOnDesktop = true;
    ShowRemovableMediaOnDesktop = true;
    ShowMountedServersOnDesktop = false;

    NewWindowTarget = "Other";
    NewWindowTargetPath = "file:///Users/${username}/";
  };

  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;
    AppleShowAllFiles = true;
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
    ApplePressAndHoldEnabled = false;
    "com.apple.keyboard.fnState" = true;
  };

  system.defaults.screencapture = {
    location = "~/Pictures/Screenshots";
    type = "png";
  };

  system.defaults.controlcenter = {
    Bluetooth  = true;
    Sound      = true;
    Display    = false;
    NowPlaying = true;
    FocusModes = false;

    BatteryShowPercentage = true;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.inputmethod.Kotoeri" = {
      "JIMPrefLiveConversionKey" = false;
    };
    NSGlobalDomain = {
      "com.apple.mouse.linear" = true;
    };
    "com.apple.finder" = {
      "FXPreferredViewStyle" = "clmv";
    };
    "com.apple.screencapture" = {
      name = "SS";
    };
    "com.apple.TextInputMenuAgent" = {
      "NSStatusItem Visible Item-0" = false;
    };
    "com.apple.TextInputMenu" = {
      visible = false;
    };
  };

  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;
}
