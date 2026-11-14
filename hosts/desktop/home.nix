{ config, pkgs, inputs, lib, ... }:

{
  imports = 
    [ # Include common home-manager submodule
      ../home.nix
    ];

    # Creates a `.desktop` entry in `~/.config/autostart` in order
    # to start Discord minimized
    xdg.configFile = {
      "autostart/discord-minimized.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Exec=${pkgs.discord}/opt/Discord/.Discord-wrapped --start-minimized
        Hidden=false
        NoDisplay=false
        Name=.Discord-wrapped
        Icon=${pkgs.discord}/opt/Discord/discord.png
        Comment=Text and voice chat for gamers.
        X-GNOME-Autostart-enabled=true
      '';
    };

  # Detail desktop specific home-manager settings

  # Sets user environmental variables thru Systemd i.e. 
  # on other distros this would be thru ~/.config/environment.d
  # This is set for the `USER` ***NOT*** globally. For global variables,
  # see the option `environment.sessionVariables` within ~/nixos-config/hosts/configuration.nix
  # ONLY WORKS on KDE and GNOME (https://wiki.archlinux.org/title/Environment_variables#Per_Wayland_session)
  systemd.user.sessionVariables = { __GL_SHADER_DISK_CACHE_SIZE = 12000000000; MANGOHUD = 1; };
}
