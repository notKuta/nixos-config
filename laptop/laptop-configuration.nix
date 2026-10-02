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

  # TAILSCALE NETWORKING STACK
  # OPTIMIZATIONS MADE FOR MODERN NFTABLES INSTEAD OF LEGACY IPTABLES
  # Enable the service and the firewall
    services.tailscale.enable = true;
    services.tailscale.useRoutingFeatures = "client";
    networking.nftables.enable = true;
    networking.firewall = {
      enable = true;
      # Always allow traffic from your Tailscale network
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      # Allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ];
  };

  # Force tailscaled to use nftables (Critical for clean nftables-only systems)
  # This avoids the "iptables-compat" translation layer issues.
  systemd.services.tailscaled.serviceConfig.Environment = [ 
    "TS_DEBUG_FIREWALL_MODE=nftables" 
  ];

  # Optimization: Prevent systemd from waiting for network online 
  # (Optional but recommended for faster boot with VPNs)
  systemd.network.wait-online.enable = false; 
  boot.initrd.systemd.network.wait-online.enable = false;

  # Enables use of fingerprint reader for unlocking the user / system
  services.fprintd.enable = true;
  # Disables su, sudo, polkit auth, or login with fingerprint; allows unlocking of previous sessions however
  # See the following Arch WiKi entry as to why: https://wiki.archlinux.org/title/Fprint
  # These pam services live in `/etc/pam.d/`; might need to disable others as well as fprintd lives in other files
  security.pam.services.login.fprintAuth = false;
  security.pam.services.su.fprintAuth = false;
  security.pam.services.sudo.fprintAuth = false;
  security.pam.services.polkit-1.fprintAuth = false;

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

