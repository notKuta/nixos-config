# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Includes the common, shared packages between systems
      ../configuration.nix
    ];

  #####################################################
  ##################### PROGRAMS ######################
  #####################################################

  programs.coolercontrol.enable = true;

  # This option may be set in multiple different locations ie
  # desktop/ & laptop/ & hosts/ as NixOS will merge all of them into
  # one unified list
  environment.systemPackages = with pkgs;
  [
    btop-cuda
  ];

  #######################################################
  ###################  NETWORKING  ######################
  #######################################################

  # Set hostname
  networking.hostName = "poseidon";

  ######################################################
  ################# BOOT / BOOTLOADER ##################
  ######################################################

  # Installs `zenpower` kernel driver and plugs the `k10temp` kernel
  # module to read temperature & wattage (?) of AMD Ryzen cpus
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenergy ];
  # This option may be set in multiple different locations ie
  # desktop/ & laptop/ & hosts/ as NixOS will merge all of them into
  # one unified list
  boot.kernelModules = [ "k10temp" ];

  #####################################################
  ################# GRAPHICS DRIVER ###################
  #####################################################
  
   # Enable NVIDIA modules
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  # hardware.nvidia.modesetting.enable = true;
  # Specify what package for nvidia drivers
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest;
  # hardware.nvidia.powerManagement.enable = true;

  #####################################################
  ################## MISCELLANEOUS ####################
  #####################################################

  swapDevices = [{
    device = "/swapfile";
    size = 32 * 1024; # 32 GiB
  }];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
