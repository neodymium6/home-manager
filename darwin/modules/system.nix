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
  };

  system.defaults.screencapture = {
    location = "~/Pictures/Screenshots";
    type = "png";
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
  };

  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  system.defaults.".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;
}
