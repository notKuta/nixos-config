{
  description = "A flake to define the system (with unstable packages)";

  inputs = {
    # Main Nix package repo; unstable branch
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Utility to declaratively manage home directory
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Utility to declaratively manage KDE Plasma & its app suite
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Framework Laptop Hardware quirks
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # An Anime Game Launcher
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      # Or, if you follow Nixkgs release 26.05:
      # aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Name of nixpkgs input you want to use
    };
    
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, plasma-manager, nixos-hardware, aagl, ... }@inputs:
    let
      system = "x86_64-linux";
      homeConfig = homeConfigFile: {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        extraSpecialArgs = { inherit inputs; };
        sharedModules = [ plasma-manager.homeModules.plasma-manager ];
        users.kuta = homeConfigFile; # replace <kuta> with new username if changed
      };
    in
    {
      nixosConfigurations = {

        # replace 'poseidon' with new hostname if needed for desktop
        "poseidon" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules =
          [
            ./hosts/desktop/configuration.nix
            home-manager.nixosModules.default
            {
              home-manager = (homeConfig ./hosts/desktop/home.nix);
            }
            nix-flatpak.nixosModules.nix-flatpak
            aagl.nixosModules.default
          ];
        };

        # replace 'neptune' with new hostname if needed for laptop
        "neptune" = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules =
          [
            ./hosts/laptop/configuration.nix
            home-manager.nixosModules.default
            {
              home-manager = (homeConfig ./hosts/laptop/home.nix);
            }
            nix-flatpak.nixosModules.nix-flatpak
            aagl.nixosModules.default
            nixos-hardware.nixosModules.framework-intel-core-ultra-series3
          ];
        };
    };};
}
