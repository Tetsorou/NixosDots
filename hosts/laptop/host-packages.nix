{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # protonvpn-gui # VPN
    github-desktop
    gtkimageview
    # pokego # Overlayed
    steghide
    arduino-ide
    gtk3
    rar
    zip
    xarchiver
    # kiwix
    # davinci-resolve
    anki
    # ghidra
    # godot_4
    jetbrains-toolbox
    exercism
    sl
    jdk21
    # discord
    # rustup
    # rustlings
    # zap
    # burpsuite
    # metasploit
    # ffuf
    vscode
    obsidian
    bat
    quickemu
    eog
    # openvpn
    koreader
    uutils-coreutils
    espanso-wayland
    # pureref
    # android-studio
    zenity
    libreoffice
    # sunshine
    # moonlight-qt
    # qpwgraph
    # kdePackages.kdenlive
    # wayvnc
    # samba
    # bottles
  ];
  swapDevices = [{
     device = "/swapfile";
     size = 8 * 1024; # 16GB
   }];
  #  services.dnsmasq.enable = true;

  # services.samba = {
  #   enable = true;
  #   settings = {
  #     "public" = {
  #       "path" = "/public";
  #       "read only" = "yes";
  #       "browseable" = "yes";
  #       "guest ok" = "yes";
  #       "comment" = "Public samba share.";
  #     };
  #   };
  # };

  services.tailscale = {
    enable = true;
    # Enable tailscale at startup

    # If you would like to use a preauthorized key
    #authKeyFile = "/run/secrets/tailscale_key";

  };


# networking.firewall.enable = true;
# networking.firewall.allowPing = true;

}
