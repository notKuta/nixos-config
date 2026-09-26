# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./laptop-hardware-configuration.nix
      # Include common files
      ../common.nix
    ];

  networking.hostName = "neptune"; # Define your hostname.

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16 GiB
  }];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Enables use of fingerprint reader for unlocking the user / system during the
  # display manager

  # THERE IS A CURRENT ISSUE WITH SDDM WHERE YOU CANNOT UNLOCK THE DISPLAY MANAGER
  # WITH ONLY THE FINGERPRINT READER OR WITH ONLY THE PASSWORD; IT IS IMPOSSIBLE FOR
  # ONLY FINGERPRINT READER; IT IS POSSIBLE WITH PASSWORD BUT YOU MUST INPUT YOUR FINGERPRINT
  # AFTER INPUTTING YOUR PASSWORD OR ELSE THE LOGIN WILL HANG (SDDM DOES NOT WARM YOU OF THIS)
  # SO ITS A SUBPAR EXPERIENCE

  # ALSO THE THREE COMMENTS LINES ARE THE ONES ACTUALLED USED FOR THIS SYSTEM

  # Install the driver
  ###services.fprintd.enable = true;
  # If simply enabling fprintd is not enough, try enabling fprintd.tod...
  ###services.fprintd.tod.enable = true;
  # ...and use one of the next four drivers
  ###services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix; # Goodix driver module
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-elan; # Elan(04f3:0c4b) driver
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090; # (Marked as broken as of 2025/04/23!) driver for 2016 ThinkPads
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a; # Goodix 550a driver (from Lenovo)

  # however for focaltech 2808:a658, use fprintd with overidden package (without tod)
  # services.fprintd.package = pkgs.fprintd.override {
  #   libfprint = pkgs.libfprint-focaltech-2808-a658;
  # };
  # this package is deprecated as of 2026 due to copyright reasons, you may search the internet for archived caches

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

