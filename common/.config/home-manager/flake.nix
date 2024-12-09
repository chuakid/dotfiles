{
  description = "Home Manager configuration of kelvin";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    {
      homeConfigurations = {
        kelvin = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./common.nix ];
          extraSpecialArgs = {
            username = "kelvin";
            homeDirectory = "/home/kelvin";
          };
        };
        SP13304 = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-darwin;
          modules = [ ./work.nix ];
          extraSpecialArgs = {
            username = "SP13304";
            homeDirectory = "/Users/SP13304";
          };
        };
      };
    };
}
