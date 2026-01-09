# home-manager

Personal dotfiles and system configuration managed with Nix, Home Manager, and nix-darwin.

## Structure

```
home-manager/
├── config/          # Application configuration files
├── darwin/          # macOS (nix-darwin) configuration
│   ├── configuration.nix
│   └── modules/
│       ├── applications.nix
│       ├── fonts.nix
│       ├── homebrew.nix
│       └── system.nix
├── home/            # home-manager modules
│   ├── dotfiles.nix
│   ├── packages.nix
│   └── programs.nix
├── flake.nix        # Flake configuration
└── home.nix         # Main entry point
```

## Customization

User information is centralized in `flake.nix`:
```nix
username = "neodymium6";
gitName = "neodymium6";
gitEmail = "104201402+neodymium6@users.noreply.github.com";
```

Configuration is organized into modules:
- **Linux & macOS**: `home/` directory
- **macOS only**: `darwin/` directory
