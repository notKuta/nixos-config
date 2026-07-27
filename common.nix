{ pkgs, config, inputs, ... }:

{

  ########################
  #### DISPLAY SERVER ####
  ########################
 
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  ########################
  ######### AUDIO ########
  ########################
 
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

  ########################
  ######### USERS ########
  ########################
  
  users.users."kuta" = {
    isNormalUser = true;
    description = "kuta";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  ########################
  ###### NETWORKING ######
  ########################

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
 
  ##############################
  #### SYSTEM-WIDE PACKAGES ####
  ##############################

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
  #  pkgs.git (currently installed through home-manager)
     pkgs.tealdeer
     pkgs.xivlauncher
     inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  #  pkgs.bash
  #  wget
  ];



}
