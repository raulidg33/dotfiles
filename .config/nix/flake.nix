{
  description = "Main Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
				pkgs.alt-tab-macos
				pkgs.appcleaner
				pkgs.arc-browser
				pkgs.cocoapods
				pkgs.discord
				pkgs.docker
				pkgs.flutter
				pkgs.fzf
				pkgs.iina
				pkgs.keka
				pkgs.mas
				pkgs.meslo-lgs-nf
				pkgs.moonlight-qt
				pkgs.neofetch
        pkgs.neovim
				pkgs.nmap
				pkgs.oh-my-posh
				pkgs.pgadmin4
				pkgs.pnpm
				pkgs.postgresql # service
				pkgs.postman
				pkgs.python310
				pkgs.raycast
				pkgs.vscode
				pkgs.wget
				pkgs.zoom-us
				pkgs.zoxide
      ];
      
      # homebrew apps and config
      homebrew = {
        enable = true;
        brews = [
					"noclamshell" # service
					"node"
				];
        casks = [
					"adobe-creative-cloud"
					"arduino"
					"azure-data-studio"
					"betterdisplay"
					"cloudflare-warp"
					"desktoppr"
					"dropbox"
					"godot"
					"google-chrome"
					"jordanbaird-ice"
					"macs-fan-control"
					"microsoft-teams"
					"kitty"
					"nikitabobko/tap/aerospace"
					"scroll-reverser"
					"setapp"
					"steam"
					"vmware-fusion"
					"webex"
					"zed"
				];
        masApps = {
					"Color Picker" = 1545870783;
					"Dropover" = 1355679052;
					"Infuse" = 1136220934;
					"Hand Mirror" = 1502839586;
					"Microsoft Excel" = 462058435;
					"Microsoft PowerPoint" = 462062816;
					"Microsoft Remote Desktop" = 1295203466;
					"Microsoft Word" = 462054704;
					"SecurID Authenticator" = 318038618;
					"ServerCat" = 1501532023;
					"Strongbox" = 897283731;
					"Telegram" = 747648890;
					"Unsplash Wallpapers" = 1284863847;
					"WhatsApp" = 310633997;
					"Xcode" = 497799835;
				};
				onActivation.autoUpdate = true;
				onActivation.upgrade = true;
      };

      # fonts
      # configuration
      system.defaults = {
        # finder
        finder.FXPreferredViewStyle = "clmv";
        finder.ShowPathbar = true;
				finder.ShowStatusBar = true;
				# launch services
				LaunchServices.LSQuarantine = false;
				# login window
				loginwindow.GuestEnabled = false;
				# menu bar
				menuExtraClock.ShowDate = 2;
        # spaces
				spaces.spans-displays = true;
				# trackpad
				trackpad.FirstClickThreshold = 2;
				trackpad.SecondClickThreshold = 2;
				# window manager
				WindowManager.EnableStandardClickToShowDesktop = false;
				# dock
				dock.show-recents = false;
        dock.persistent-apps = [
					"/System/Applications/Launchpad.app"
					"${pkgs.arc-browser}/Applications/Arc.app"
					"/System/Applications/Messages.app"
					"/Applications/Telegram.app"
					"/Applications/WhatsApp.app"
					"/Applications/Microsoft Teams.app"
					"/System/Applications/Mail.app"
					"/Applications/kitty.app"
					"${pkgs.vscode}/Applications/Visual Studio Code.app"
					"/Applications/Zed.app"
					"/Applications/Azure Data Studio.app"
					"/Applications/ServerCat.app"
					"/System/Applications/Calendar.app"
					"/System/Applications/Reminders.app"
					"/System/Applications/Notes.app"
					"/Applications/Microsoft Excel.app"
					"/Applications/Microsoft Word.app"
					"/Applications/VMware Fusion.app"
					"/Applications/Windows App.app"
					"/System/Applications/iPhone Mirroring.app"
					"/System/Applications/TV.app"
					"/System/Applications/Music.app"
					"/System/Applications/App Store.app"
					"/System/Applications/System Settings.app"
				];
      };

      security.pam.enableSudoTouchIdAuth = true;

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."main" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration
				nix-homebrew.darwinModules.nix-homebrew
				{
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "raulido";
            autoMigrate = true;
          };
				}
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."main".pkgs;
  };
}
