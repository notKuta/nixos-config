{ pkgs, config, inputs, ... }:

{
  # Sets garbage-collector to run every week
  # and only delete generations older than 30 days
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-30d";
  };

  services.flatpak = {
    enable = true;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
    packages = [
      "flathub:app/app.zen_browser.zen/x86_64/stable"
    ];
    overrides = {
      "global".Context = {
        filesystems = [
          "home"
        ];
        sockets = [
          "!x11"
          "!fallback-x11"
        ];
      };
    };
  };

  ########################
  #### DISPLAY SERVER ####
  ########################
 
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # services.xserver.enable = true;

  # Enable old login manager
  # services.displayManager.sddm.enable = true;

  services.displayManager.plasma-login-manager.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    elisa
  ];

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
      # Enables rnn-noise plugin to be made w/ home-manager
      extraLadspaPackages = [ pkgs.rnnoise-plugin pkgs.ladspaPlugins ];

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
    extraGroups = [ "networkmanager" "wheel" "gamemode" ];
    /*
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];*/
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

  # DNS Settings for systemd-resolve
  services.resolved = {
    enable = true;
    settings.Resolve = {
        DNSOverTLS = "true";
        DNSSEC = "true";
        Domains = [ "~." ];
        DNS =
        ''
        DNS=45.90.28.0#cd5dc8.dns.nextdns.io
        DNS=2a07:a8c0::#cd5dc8.dns.nextdns.io
        DNS=45.90.30.0#cd5dc8.dns.nextdns.io
        DNS=2a07:a8c1::#cd5dc8.dns.nextdns.io
        '';
        FallbackDNS = [
          "1.1.1.1"
          "1.0.0.1"
        ];
    };
  };
  
  security.tpm2 = {
    enable = true;
    abrmd.enable = true;
    pkcs11.enable = true;

    tctiEnvironment.enable = true;
    tctiEnvironment.interface = "tabrmd";
  };
 
  ##############################
  #### SYSTEM-WIDE PACKAGES ####
  ##############################

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Forces Firefox to run under Xwayland; fixes menus not
  # displaying correctly using FirefoxPWAs
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "0";

  programs = { 
    firefox = {
      enable = true;
      nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
    };
    steam = {
      enable = true;
      # Fixes Xorg cursor issues
      extraPackages = with pkgs; [ kdePackages.breeze mangohud gamemode xivlauncher faugus-launcher ];

    };

    vim = {
      enable = true;
      defaultEditor = true;
    }; 

    bash = { 
      shellAliases = { ll = "ls -al"; icat = "kitten icat"; };
      enable = true;
      interactiveShellInit = "fastfetch";
    };

    coolercontrol.enable = true;

    gamemode.enable = true;

    # Oepns the TCP & UDP ports 1714 to 1764 to make it work
    kdeconnect.enable = true;

  };
  
  services.hardware.openrgb.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     fastfetch
     btop-cuda
     tealdeer
     xivlauncher
     nixd
     marksman
     dust
     protonplus
     ungoogled-chromium
     faugus-launcher
     sunshine
     haruna
     kdePackages.filelight
     webcord
     firefoxpwa
  #  wget
  ];

  ##############################
  ######### BOOTLOADER #########
  ##############################

  # Bootloader.
  boot.loader.limine.enable = true;
  boot.loader.limine.efiSupport = pkgs.stdenv.hostPlatform.isEfi;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [{ 
     device = "/swapfile"; 
     size = 32 * 1024; # 32 GiB
  }];

  boot.zswap = {
    enable = true; 
    # …
  };

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
