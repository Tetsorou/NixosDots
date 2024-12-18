let pkgs = import <nixpkgs> {}; in
pkgs.callPackage ({ stdenv, pkgs, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "testpoc";

  src = fetchFromGitHub {
    owner = "nvchad";
    repo = "nvchad";
    rev  = "08a16b9201c13eb244b14dcc8e1e078a0ac76725";
    sha256 = "1kl2psvimq5vlhrn9isgbkpq140f9lmli937n9y87gc3017pj8m8";
  };

   test = pkgs.writeText "test" ''
    # This rule was added by Solaar.
#
# Allows non-root users to have raw access to Logitech devices.
# Allowing users to write to the device is potentially dangerous
# because they could perform firmware updates.
KERNEL=="uinput", SUBSYSTEM=="misc", TAG+="uaccess", OPTIONS+="static_node=uinput"

ACTION != "add", GOTO="solaar_end"
SUBSYSTEM != "hidraw", GOTO="solaar_end"

# USB-connected Logitech receivers and devices
ATTRS{idVendor}=="046d", GOTO="solaar_apply"

# Lenovo nano receiver
ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="6042", GOTO="solaar_apply"

# Bluetooth-connected Logitech devices
KERNELS == "0005:046D:*", GOTO="solaar_apply"

GOTO="solaar_end"

LABEL="solaar_apply"

# Allow any seated user to access the receiver.
# uaccess: modern ACL-enabled udev
TAG+="uaccess"

# Grant members of the "plugdev" group access to receiver (useful for SSH users)
#MODE="0660", GROUP="plugdev"

LABEL="solaar_end"
# vim: ft=udevrules
  '';

  installPhase = ''
    mkdir $out
    cp $test /etc/udev/rules.d/42-logitech-unify-permissions.rules
  '';
}) {}