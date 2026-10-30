{ config, pkgs, inputs, lib, ... }:

{
  imports =
    [ # Common home-manager submodule
      ../home.nix
    ];

  # Detail laptop-specific home-manager settings here

  # Enables official systray applet for Tailscale
  services.tailscale-systray.enable = true;

}
