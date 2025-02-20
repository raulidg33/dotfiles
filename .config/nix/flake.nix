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
		configuration = { pkgs, config, ... }: {

		nixpkgs.config.allowUnfree = true;

		# List packages installed in system profile. To search by name, run:
		# $ nix-env -qaP | grep wget
		environment.systemPackages = [
			pkgs.act
			pkgs.alt-tab-macos
			pkgs.appcleaner
			pkgs.btop
			pkgs.chromedriver
			pkgs.cocoapods
			pkgs.discord
			pkgs.docker
			pkgs.flutter
			pkgs.fzf
			pkgs.gh
			pkgs.iina
			pkgs.keka
			pkgs.mas
			# pkgs.meslo-lgs-nf
			pkgs.moonlight-qt
			pkgs.mos
			pkgs.neofetch
			pkgs.neovim
			pkgs.nmap
			# pkgs.oh-my-posh
			pkgs.pnpm
			pkgs.postgresql # service
			pkgs.postman
			pkgs.python311
			pkgs.python311Packages.pip
			pkgs.raycast
			pkgs.ripgrep
			pkgs.sqlitebrowser
			pkgs.stow
			pkgs.vscode
			pkgs.wget
			pkgs.zoom-us
			pkgs.zoxide
		];
		
		# homebrew apps and config
		homebrew = {
			enable = true;
			brews = [
				"node"
				"oh-my-posh"
				"7zip"
			];
			casks = [
				"adobe-creative-cloud"
				"altserver"
				"arc"
				"arduino"
				"azure-data-studio"
				"betterdisplay"
				"cloudflare-warp"
				"crossover"
				"desktoppr"
				"docker"
				"dropbox"
				"ghostty"
				"godot"
				"google-chrome"
				"itsycal"
				"jordanbaird-ice"
				# "kitty"
				# "linearmouse"
				"macs-fan-control"
				"microsoft-teams"
				"nikitabobko/tap/aerospace"
				"qmk-toolbox"
				"pgadmin4"
				"rustdesk"
				"setapp"
				"steam"
				"swiftdefaultappsprefpane"
				"via"
				"vmware-fusion"
				"webex"
				"zed"
				"zen-browser"
			];
			taps = [
				"nikitabobko/tap"
			];
			masApps = {
				"Amazon Prime Video" = 545519333;
				"Color Picker" = 1545870783;
				"Dropover" = 1355679052;
				"Infuse" = 1136220934;
				"Hand Mirror" = 1502839586;
				"Keynote" = 409183694;
				"Microsoft Excel" = 462058435;
				"Microsoft PowerPoint" = 462062816;
				"Microsoft Remote Desktop" = 1295203466;
				"Microsoft Word" = 462054704;
				"Numbers" = 409203825;
				"Pages" = 409201541;
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
			onActivation.cleanup = "zap";
		};

		# fonts
		fonts.packages = [
			(pkgs.nerdfonts.override { fonts = ["JetBrainsMono"]; })
		];
		
		system.activationScripts.applications.text = let
  			env = pkgs.buildEnv {
    				name = "system-applications";
    				paths = config.environment.systemPackages;
   				pathsToLink = "/Applications";
 			};
		in
  			pkgs.lib.mkForce ''
  				# Set up applications.
  				echo "setting up /Applications..." >&2
  				rm -rf /Applications/Nix\ Apps
  				mkdir -p /Applications/Nix\ Apps
  				find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
  				while read -r src; do
   					app_name=$(basename "$src")
					echo "copying $src" >&2
					${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
  				done
     			'';

		# configuration
		system.defaults = {
			# finder
			finder.AppleShowAllExtensions = true;
			finder.FXPreferredViewStyle = "clmv";
			finder.ShowPathbar = true;
			finder.ShowStatusBar = true;
			# launch services
			LaunchServices.LSQuarantine = false;
			# login window
			loginwindow.GuestEnabled = false;
			# menu bar
			menuExtraClock.ShowDate = 2;
			menuExtraClock.ShowDayOfWeek = false;
			menuExtraClock.ShowDayOfMonth = false;
			# spaces
			spaces.spans-displays = false;
			# trackpad
			trackpad.FirstClickThreshold = 2;
			trackpad.SecondClickThreshold = 2;
			# window manager
			WindowManager.EnableStandardClickToShowDesktop = false;
			# dock
			dock.expose-group-by-app = true;
			dock.show-recents = false;
			dock.wvous-br-corner = 1;
			dock.persistent-apps = [
				"/System/Applications/Launchpad.app"
				"/Applications/Arc.app"
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
		system.defaults.CustomUserPreferences = {
      # Sets Downloads folder with fan view in Dock
      "com.apple.dock" = {
        persistent-others = [
          {
            "tile-data" = {
              "file-data" = {
                "_CFURLString" = "/Users/raulido/Downloads";
                "_CFURLStringType" = 0;
              };
              "arrangement" = 2;
              "displayas" = 0;
            };
            "tile-type" = "directory-tile";
          }
          {
            "tile-data" = {
              "file-data" = {
                "_CFURLString" = "/Users/raulido/Dropbox";
                "_CFURLStringType" = 0;
              };
              "displayas" = 1;
            };
            "tile-type" = "directory-tile";
          }
        ];
      };
    };

		security.pam.enableSudoTouchIdAuth = true;
		
		programs.zsh.enable = true;
		
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
