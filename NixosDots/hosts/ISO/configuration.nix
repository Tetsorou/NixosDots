{
  pkgs,
  inputs,
  modulesPath,
  username,
  ...
}: {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    inputs.home-manager.nixosModules.home-manager
    ../modules/core
    ../modules/hardware/opengl.nix

    ../../modules/desktop/hyprland # Enable hyprland window manager
    ../modules/programs/terminal/alacritty
    # ../modules/programs/terminal/kitty
    ../modules/programs/shell/bash
    ../modules/programs/shell/zsh
    ../modules/programs/browser/firefox
    ../modules/programs/editor/nixvim
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
  ];

  # Filesystems support
  boot.supportedFilesystems = ["ntfs" "exfat" "ext4" "fat32" "btrfs"];
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Home-manager config
  home-manager.users.${username} = {
    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.stateVersion = "24.05"; # Please read the comment before changing.

    home.packages = with pkgs; [
      calamares-nixos
      xfce.thunar

      # Terminal
      #vim
      eza
      fzf
      fd
      git
      gh
      lf
      nix-prefetch-scripts
      neofetch
    ];

    home.sessionVariables = {
      # EDITOR = "emacs";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  environment.systemPackages = with pkgs; let
    sddm-themes = pkgs.callPackage ../../modules/themes/sddm/themes.nix {};
    scripts = pkgs.callPackage ../../modules/scripts {};
  in [
    # System
    scripts.tmux-find
    scripts.collect-garbage
    # sddm-themes.sugar-dark
    sddm-themes.astronaut
    # sddm-themes.tokyo-night
    # adwaita-qt
    bibata-cursors
    libsForQt5.qt5.qtgraphicaleffects # For sddm to function properly
    polkit
    libsForQt5.polkit-kde-agent

    # Development
    # devbox # faster nix-shells
    # shellify # faster nix-shells
    github-desktop
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-linux";
    overlays = [
      inputs.nur.overlay
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  security = {
    polkit.enable = true;
    #sudo.wheelNeedsPassword = false;
  };

  xdg.portal.enable = true;
  xdg.portal.configPackages = [pkgs.xdg-desktop-portal-gtk];

  # Enable dconf for home-manager
  programs.dconf.enable = true;

  # Enable sddm login manager
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.theme = "sugar-dark";
  services.xserver.displayManager.sddm.settings.Theme.CursorTheme = "Bibata-Modern-Classic";

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

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Default user when using: sudo nixos-rebuild build-vm
  users.users.nixosvmtest.isNormalUser = true;
  users.users.nixosvmtest.initialPassword = "vm";
  users.users.nixosvmtest.group = "nixosvmtest";
  users.groups.nixosvmtest = {};

  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "FiraCode"
      ];
    })
  ];

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "input"
      "disk"
      "libvirtd"
      "video"
      "audio"
    ];
  };

  nix = {
    settings = {
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
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
    package = pkgs.nixFlakes;
  };

  fileSystems."/mnt/seagate" = {
    device = "/dev/disk/by-uuid/E212-7894";
    fsType = "auto";
    options = [
      "X-mount.mkdir"
      "nofail"
      "async"
      # "auto"
      "rw"
      "exec"
      "user"
      "uid=1000"
      "gid=100"
      "umask=000"
      # "dev"
      # "suid"
      "x-gvfs-show"
      "x-systemd.automount"
      "x-systemd.mount-timeout=5"
    ];
  };

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/01DA12C1CBDE9100";
    fsType = "lowntfs-3g";
    options = [
      "X-mount.mkdir"
      "nofail"
      "async"
      "rw"
      "exec"
      "user"
      "uid=1000"
      "gid=100"
      "umask=000"
      "x-gvfs-show"
      "x-systemd.mount-timeout=5"
    ];
  };
}
