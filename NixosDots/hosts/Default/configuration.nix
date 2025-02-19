{
  pkgs,
  username,
  locale,
  timezone,
  terminal,
  hostname,
  ...
}: {
  imports = [
    ../common.nix
    ../../modules/desktop/gnome
    ../../modules/desktop/hyprland # Enable hyprland window manager
    ../../modules/programs/games
   # ../../modules/desktop/gnome
#    ../../modules/hardware/video/nvidia.nix # Enable nvidia proprietary drivers
    ../../modules/hardware/video/opengl.nix
    # ../../modules/hardware/video/amdgpu.nix # Enable amdgpu drivers
    ./hardware-configuration.nix
  ];

  # Home-manager config
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      #vim
     # krita

       godot_4

      #steam
    ];
    home.sessionVariables = {
      EDITOR = "code";
      BROWSER = "firefox";
      TERMINAL = terminal;
    };
  };
  services.flatpak.enable = true;
  environment.systemPackages = with pkgs; [
       bluez-experimental
      godot_4
      steghide
      appimage-run
      jetbrains-toolbox
     # helix
      exercism
      ani-cli
      killall
      sl
      piper
      jdk21
      libratbag
      cmake
      gcc
      brightnessctl
      hyfetch
      libclang
      wezterm
      m2libc
      nodejs_22
      go
      #lunarvim
      python3
      aseprite
     # chromium
      audacity
      #wpsoffice
      #libreoffice-qt6
      libreoffice-qt
      alejandra
  ];

  # Enable networking
  networking = {
    hostName = hostname; # Define your hostname.
    networkmanager.enable = true;
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Timezone and locale
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "ctrl:swapcaps";
    };
    
  };
  services.displayManager.defaultSession = "hyprland";
  console.keyMap = "us"; # Configure console keymap
  services.printing.enable = false; # Enable CUPS to print documents.

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "kvm"
      "input"
      "disk"
      "libvirtd"
      "video"
      "audio"
      "dialout"
    ];
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment? 
}
