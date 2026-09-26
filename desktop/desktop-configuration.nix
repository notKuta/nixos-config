# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./desktop-hardware-configuration.nix
      # Includes the common, shared packages between systems
      ./common.nix
    ];
  # Set hostname
  networking.hostName = "poseidon";

  # Installs `zenpower` kernel driver and plugs the `k10temp` kernel
  # module to read temperature & wattage (?) of AMD Ryzen cpus 
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenergy ];
  boot.kernelModules = { k10temp = true; ntsync = true; };
  
  # Needed for hibernation with swapfile---in tandem with `resume.Device` being set
  # May be device specific and is why I set the kernel params specifc to desktop
  # `boot.resumeDevice` is in `common.nix`
  # See the Arch wiki for more: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation_into_swap_file
  # boot.kernelParams = [ "resume_offset=61440" ];

  # Sets the targeted resume device from waking from hibernation
  # For swapfiles (which we use), you must also set the `physical_offset`
  # kernel param for it to work. This is currently set in `desktop-config.nix`
  # boot.resumeDevice = "/dev/disk/by-uuid/6a4d6992-9ebf-4bc4-b90a-a7bfcfb95561";
  
   # Enable NVIDIA modules
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.nvidia.modesetting.enable = true;
  # Comment out to specify what package for nvidia drivers
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  hardware.nvidia.powerManagement.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "26.05"; # Did you read the comment?

}
