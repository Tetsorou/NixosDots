# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/ff25d392-06e6-4f8d-b1a7-374868e60412";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-e52567a6-992a-46f7-aec9-a838f4bdc340".device = "/dev/disk/by-uuid/e52567a6-992a-46f7-aec9-a838f4bdc340";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B094-0F07";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # swapDevices =
    # [ { device = "/dev/disk/by-uuid/dfd43cb7-4297-4c50-a5e6-8130349fac9b"; }
    # ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp58s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
