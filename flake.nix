{
  description = "A flake to define the system (with unstable packages)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
      # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
#    nix-flatpak.url = "github:gmodena/nix-flatpak/";

  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: { # nix-flatpak,
    # replace '.poseidon' with new hostname if needed
    nixosConfigurations.poseidon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./desktop-configuration.nix #nix-flatpak.nixosModules.nix-flatpak
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
