{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    protonvpn-gui # VPN
    github-desktop
    gtkimageview
    # pokego # Overlayed
    steghide
    arduino-ide
    gtk3
    rar
    zip
    xarchiver
    kiwix
    davinci-resolve
    anki
    ghidra
    godot_4
    jetbrains-toolbox
    exercism
    sl
    jdk21
    # discord
    rustup
    rustlings
    zap
    burpsuite
    metasploit
    ffuf
    vscode
    obsidian
    bat
    quickemu
    eog
    openvpn
    koreader
    uutils-coreutils
    espanso-wayland
    pureref
    android-studio
    zenity
    libreoffice
    sunshine
    moonlight-qt
    qpwgraph
    # samba
    # bottles
  ];
  swapDevices = [{
     device = "/swapfile";
     size = 16 * 1024; # 16GB
   }];
  #  services.dnsmasq.enable = true;


#   services.samba = {
#   enable = true;
#   securityType = "user";
#   openFirewall = true;
#   settings = {
#     global = {
#       "workgroup" = "WORKGROUP";
#       "server string" = "smbnix";
#       "netbios name" = "smbnix";
#       "security" = "user";
#       #"use sendfile" = "yes";
#       #"max protocol" = "smb2";
#       # note: localhost is the ipv6 localhost ::1
#       "hosts allow" = "192.168.0. 127.0.0.1 localhost";
#       "hosts deny" = "0.0.0.0/0";
#       "guest account" = "nobody";
#       "map to guest" = "bad user";
#     };
#     "public" = {
#       "path" = "/mnt/Shares/Public";
#       "browseable" = "yes";
#       "read only" = "no";
#       "guest ok" = "yes";
#       "create mask" = "0644";
#       "directory mask" = "0755";
#       "force user" = "username";
#       "force group" = "groupname";
#     };
#     "private" = {
#       "path" = "/mnt/Shares/Private";
#       "browseable" = "yes";
#       "read only" = "no";
#       "guest ok" = "no";
#       "create mask" = "0644";
#       "directory mask" = "0755";
#       "force user" = "username";
#       "force group" = "groupname";
#     };
#   };
# };

# services.samba-wsdd = {
#   enable = true;
#   openFirewall = true;
# };

# networking.firewall.enable = true;
# networking.firewall.allowPing = true;

}
