{ pkgs, ... }:
{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # Nerd Fonts
      maple-mono.NF
      pkgs.nerd-fonts.jetbrains-mono

      # Normal Fonts
      noto-fonts
      noto-fonts-color-emoji

      jigmo
    ];
    fontconfig = {
      enable = true;
      antialias = true;
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "Maple Mono NF"
          "jigmo"
          "Noto Mono"
          "DejaVu Sans Mono" # Default
        ];
        sansSerif = [
          "Noto Sans"
          "DejaVu Sans" # Default
        ];
        serif = [
          "Noto Serif"
          "DejaVu Serif" # Default
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
