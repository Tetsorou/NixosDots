{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
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
    hyfetch
    # discord
    rustup
    rustlings
    zap
    burpsuite
    metasploit
    ffuf
    wakatime-cli
    vscode
    obsidian
    bat
    fooyin
    quickemu
    eog
    openvpn
    koreader
    uutils-coreutils
    espanso-wayland
    pureref
    fastfetch
    android-studio
    zenity
    libreoffice
  ];
  swapDevices = [{
     device = "/swapfile";
     size = 16 * 1024; # 16GB
   }];
}
