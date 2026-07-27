{ config, pkgs, inputs, ...}:
{
  programs = { 
      # Install firefox.
    firefox.enable = true;
      # Install steam.
    steam.enable = true;
      # Set vim as default editor
    vim = {
      enable = true;
      defaultEditor = true;
    }; 
    bash = { 
      shellAliases = { ll = "ls -al"; };
      enable = true;
      interactiveShellInit = "fastfetch";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
     #pkgs.vim  Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     pkgs.fastfetch
     pkgs.btop-cuda
     pkgs.mangohud
    #  pkgs.git
     pkgs.tealdeer
     pkgs.xivlauncher
     inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
#     pkgs.bash
     # options are: 'x86_64-linux', 'aarch64-linux' and 'aarch64-darwin'
/*
     inputs.zen-browser.packages."x86_64-linux".default # beta
     #inputs.zen-browser.packages."x86_64-linux".beta
     #inputs.zen-browser.packages."x86_64-linux".twilight
     # IMPORTANT: this package relies on the twilight release artifacts from the
     # official zen repo and those artifacts are always replaced, causing hash mismatch
     #inputs.zen-browser.packages."x86_64-linux".twilight-official

     # you can even override the package policies
     inputs.zen-browser.packages."x86_64-linux".default.override {
       extraPolicies = {
         DisableAppUpdate = true;
         DisableTelemetry = true;
      # more and more
       };
     }
*/
  #  wget
  ];
}
