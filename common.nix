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

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
     pkgs.nixd
     pkgs.marksman
     pkgs.fira-code
     pkgs.fira-code-symbols
  #  pkgs.vimPlugins.markdown-preview-nvim
  #  pkgs.bash
  #  wget
  ];

  ##############################
  ######### BOOTLOADER #########
  ##############################

  # Bootloader.
  boot.loader.limine.enable = true;
  boot.loader.limine.efiSupport = pkgs.stdenv.hostPlatform.isEfi;
  boot.loader.efi.canTouchEfiVariables = true;

  ##############################
  ########### FLAKES ###########
  ##############################

  # Enables flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ###########################################
  ########### TIMEZONES / LOCALE  ###########
  ###########################################

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
  ];

  ###########################################
  ################ PRINTING #################
  ###########################################

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  ###########################################
  ############# SUID WRAPPERS ###############
  ###########################################

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ###########################################
  ########### DAEMON / SERVICES #############
  ###########################################

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

}
