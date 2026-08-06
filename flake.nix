{
  description = "A flake to define the system (with unstable packages)";

  inputs = {
   nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

   home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    
  };

  outputs = { self, nixpkgs, home-manager, flatpaks, plasma-manager, ... }@inputs: {
    # replace '.poseidon' with new hostname if needed
    nixosConfigurations.poseidon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./desktop-configuration.nix 
        home-manager.nixosModules.default
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            extraSpecialArgs = { inherit inputs; };
            sharedModules = [plasma-manager.homeModules.plasma-manager ];
            users.kuta = ./home.nix; # replace <kuta> with new username if changed
          };
        } 
        flatpaks.nixosModules.default
      ];
    };
/*
    nixosConfigurations.neptune = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./laptop-configuration.nix 
      home-manager.nixosModules.default
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
          extraSpecialArgs = { inherit inputs; };
          users.kuta = ./home.nix; # replace <kuta> with new username if changed
        };
      } 
      ];
    };
*/
  };
}
