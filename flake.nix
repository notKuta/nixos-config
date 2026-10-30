{
  description = "A flake to define the system (with unstable packages)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

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
    
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, plasma-manager, nixos-hardware, ... }@inputs:
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
            nixos-hardware.nixosModules.framework-intel-core-ultra-series3
          ];
        };
    };};
}
