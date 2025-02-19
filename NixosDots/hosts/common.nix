{
  inputs,
  pkgs,
  username,
  terminal,
  ...
}: let
  sddm-themes = pkgs.callPackage ../modules/themes/sddm/themes.nix {};
  scripts = pkgs.callPackage ../modules/scripts {};
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../modules/hardware/video/opengl.nix
    #../modules/hardware/drives # Will still boot if these these drives are not found
    #../modules/hardware/video/nvidia.nix
    ../modules/programs/terminal/${terminal}
    ../modules/programs/shell/bash
    ../modules/programs/shell/zsh
    ../modules/programs/browser/firefox
    #../modules/programs/editor/neovim
    ../modules/programs/editor/vscode
    ../modules/programs/cli/starship
    ../modules/programs/cli/tmux
    ../modules/programs/cli/direnv
    ../modules/programs/cli/lf
    ../modules/programs/cli/lazygit
    ../modules/programs/cli/cava
    ../modules/programs/cli/btop
    ../modules/programs/misc/mpv
    ../modules/programs/misc/spicetify
    ../modules/programs/misc/obs
    ../modules/programs/misc/cpufreq
    ../modules/programs/misc/virt-manager
  ];

  # Common home-manager options that are shared between all systems.
  home-manager.users.tetsorou = {pkgs, ...}: {
    xdg.enable = true;
    home.username = "tetsorou";
    home.homeDirectory = "/home/tetsorou";

    home.stateVersion = "24.05"; # Please read the comment before changing.

    # Packages that don't require configuration. If you're looking to configure a program see the /modules dir
    home.packages = with pkgs; [
      # Applications
      #kate
      xfce.thunar

      # Terminal
      eza
      fzf
      
      fd
      git
      gh
      github-desktop
      htop
      jq
      lolcat
      nix-prefetch-scripts
      neofetch
      ripgrep
      tldr
      unzip
      (pkgs.writeShellScriptBin "hello" ''
        echo "Hello tetsorou!"
      '')
    ];
    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };
  
  # Filesystems support
  boot.supportedFilesystems = ["ntfs" "exfat" "ext4" "fat32" "btrfs"];
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Bootloader.
  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = null; # Display bootloader indefinitely until user selects OS
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "1920x1080";
        theme = pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "https://github.com/Tetsorou/NixosDots";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        };
      };
    };
  };

  security = {
    polkit.enable = true;
    #sudo.wheelNeedsPassword = false;
  };

  xdg.portal = {
    enable = true;
    configPackages = with pkgs; [xdg-desktop-portal-gtk];
  };

  # Enable dconf for home-manager
  programs.dconf.enable = true;

  # Enable sddm login manager
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "tokyo-night";
  services.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Classic";
  services.xserver.displayManager.setupCommands = '' ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --mode 1920x1080 --rate 165 --output HDMI-A-1 --rate 165 --mode 1920x1080'';
  # Setup auth agent and keyring
  services.gnome.gnome-keyring.enable = true;
  systemd = {
    user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "FiraCode"
      ];
    })
  ];

  nixpkgs = {
    config.allowUnfree = true;
    # config.allowUnfreePredicate = _: true;
    overlays = [
      inputs.nur.overlay
    ];
  };

  environment.sessionVariables = {
    # These are the defaults, and xdg.enable does set them, but due to load
    # order, they're not set before environment.variables are set, which could
    # cause race conditions.
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Scripts
    #scripts.tmux-sessionizer
    scripts.collect-garbage
    scripts.driverinfo
   # scripts.underwatt
      quickemu
      winetricks
      wineWowPackages.full
    # System
     sddm-themes.sugar-dark
   sddm-themes.astronaut
   killall
     sddm-themes.tokyo-night
    # adwaita-qt
     bibata-cursors
    libsForQt5.qt5.qtgraphicaleffects # For sddm to function properly
    # polkit
    # libsForQt5.polkit-kde-agent
    vulkan-tools
    arduino-ide
    brave
    # Development
    devbox # faster nix-shells
    xorg.xev
    anydesk
    solaar
    shellify # faster nix-shells
    frescobaldi
    acpi
    wlroots
    killall
    ventoy
    strawberry
    wl-clipboard
    gleam
    erlang
    rebar3
    jigmo
    davinci-resolve
    anki
    ghidra
    waybar-mpris
    xorg.xhost
    firefox-devedition
    wget
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
 
  nix = {
    # Nix Package Manager Settings
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      use-xdg-base-directories = false;
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };
    gc = {
      # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 20d";
    };
    optimise.automatic = true;
    package = pkgs.nixFlakes;
  };
 
}
