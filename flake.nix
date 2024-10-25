{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      nix-vscode-extensions,
      mac-app-util
    }:
    let
      darwinConfiguration =
        {
          pkgs,
          lib,
          config,
          ...
        }:
        {

          environment.systemPackages = [
            pkgs.vim
            pkgs.wget
            pkgs.lazygit
            pkgs.cargo
            pkgs.rustc
            pkgs.iterm2
            pkgs.autojump
            pkgs.thefuck
            pkgs.direnv
            pkgs.biome
            pkgs.nodejs_20
            pkgs.bun
          ];

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          system.stateVersion = 5;

          nixpkgs.config.allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "vscode"
              "vscode-with-extensions"
            ];

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

          # Allow using sudo with Touch ID
          security.pam.enableSudoTouchIdAuth = true;

          # Homebrew configuration
          homebrew = {
            enable = true;
            global = {
              autoUpdate = true;
            };
            onActivation = {
              autoUpdate = true;
              upgrade = true;
              cleanup = "uninstall";
            };
            taps = [ ];
            brews = [ ];
            casks = [
              "1password"
              "arc"
              "betterdisplay"
              "discord"
              "figma"
              "notion"
              "postman"
              "tower"
              "zed"
              "zoom"
            ];
            masApps = {
              "1Password Safari" = 1569813296;
              "Home Assistant" = 1099568401;
              "Microsoft Excel" = 462058435;
              "Microsoft PowerPoint" = 462062816;
              "Microsoft Word" = 462054704;
              "Reeder Classic" = 1529448980;
              "TestFlight" = 899247664;
              "WhatsApp" = 310633997;
              "Telegram" = 747648890;
            };
          };

          # System Settings
          system.defaults = {
            CustomUserPreferences = {
              "com.apple.Music" = {
                userWantsPlaybackNotifications = false;
              };
            };
            dock = {
              autohide = true;
              autohide-delay = 0.0;
              autohide-time-modifier = 0.4;
              expose-animation-duration = 0.4;
              launchanim = true;
              mineffect = "genie";
              minimize-to-application = true;
              orientation = "bottom";
              show-process-indicators = true;
              persistent-apps = [
                "/Applications/Arc.app"

                "${pkgs.vscode.outPath}/Applications/Visual Studio Code.app"
                "${pkgs.iterm2.outPath}/Applications/iTerm2.app"

                "/Applications/1Password.app"
                "/Applications/Slack.app"
                "/Applications/Discord.app"

                "/System/Applications/Mail.app"
                "/System/Applications/Calendar.app"
                "/System/Applications/Notes.app"

                "/System/Applications/Messages.app"
                "/Applications/WhatsApp.app"
                "/Applications/Telegram.app"

                "/System/Applications/Music.app"
                "/System/Applications/Photos.app"
                "/System/Applications/Photo Booth.app"

                "/System/Applications/Home.app"
                "/System/Applications/App Store.app"
                "/System/Applications/System Settings.app"
              ];
            };
            finder = {
              AppleShowAllExtensions = true;
              AppleShowAllFiles = false;
              FXDefaultSearchScope = "SCcf";
              FXEnableExtensionChangeWarning = false;
              FXPreferredViewStyle = "clmv";
              QuitMenuItem = false;
              ShowPathbar = true;
              ShowStatusBar = false;
            };
            loginwindow = {
              autoLoginUser = null;
              DisableConsoleAccess = false;
              GuestEnabled = false;
              LoginwindowText = "micha.de.vries@surrealdb.com";
              PowerOffDisabledWhileLoggedIn = false;
              RestartDisabled = false;
              RestartDisabledWhileLoggedIn = false;
              SHOWFULLNAME = false;
              ShutDownDisabled = false;
              ShutDownDisabledWhileLoggedIn = false;
              SleepDisabled = false;
            };
            screencapture = {
              disable-shadow = true;
              location = "~/Pictures/screenshots";
              show-thumbnail = true;
              type = "png";
            };
          };

          # System Startup settings
          system.startup = {
            chime = false;
          };
        };
    in
    {
      # Build darwin flake using:
      darwinConfigurations.michas-MacBook-Pro = nix-darwin.lib.darwinSystem {
        modules = [
          mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "micha";

              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle " = homebrew-bundle;
              };

              mutableTaps = false;
            };
          }
          darwinConfiguration
          {
            users.users.micha.home = "/Users/micha";
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.micha = import ./home.nix;

            home-manager.extraSpecialArgs = {
              inherit inputs nix-vscode-extensions;
            };

            home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations.michas-MacBook-Pro.pkgs;

      # Nix formatter
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
    };
}
