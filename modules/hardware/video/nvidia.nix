{
  lib,
  pkgs,
  config,
  ...
}: let
  nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.beta; # stable, latest, etc.
in {
  # Load nvidia driver for Xorg and Wayland
  #services.xserver.videoDrivers = ["nvidia"];
  services.xserver.videoDrivers = ["nvidia"];# or "nvidiaLegacy470 etc.
  boot.kernelParams = lib.optionals (lib.elem "nvidia" config.services.xserver.videoDrivers) [
    "nvidia-drm.modeset=1"
    "nvidia_drm.fbdev=1"
  ];
  nixpkgs.config = {
    nvidia.acceptLicense = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "cudatoolkit"
      "nvidia-persistenced"
      "nvidia-settings"
      "nvidia-x11"
    ];
  };
  hardware = {
    nvidia = {
      open = true;
      nvidiaSettings = true;
      powerManagement.enable = false; # This can cause sleep/suspend to fail and saves entire VRAM to /tmp/
      modesetting.enable = true;
      package = nvidiaDriverChannel;
      #prime = {
      #offload.enable = true;
      #sync.enable = true;

      #amdgpuBusId = "PCI:5:0:0";
#       nvidiaBusId = "PCI:1:0:0";
 #      intelBusId = "PCI:0:2:0";
#};
    };
    opengl = {
      enable = true;
      package = nvidiaDriverChannel;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl

        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer
      ];
    };
  };
}
