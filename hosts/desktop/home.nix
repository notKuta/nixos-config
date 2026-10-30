{ config, pkgs, inputs, lib, ... }:

{
  imports = 
    [ # Include common home-manager submodule
      ../home.nix
    ];

  # Detail desktop specific home-manager settings

  # Sets user environmental variables thru Systemd i.e. 
  # on other distros this would be thru ~/.config/environment.d
  # ONLY WORKS on KDE and GNOME (https://wiki.archlinux.org/title/Environment_variables#Per_Wayland_session)
  systemd.user.sessionVariables = { __GL_SHADER_DISK_CACHE_SIZE = 12000000000; MANGOHUD = 1; };
}
