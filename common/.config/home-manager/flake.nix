{
  description = "Home Manager configuration of kelvin";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, home-manager, neovim-nightly-overlay, ... }: {
    homeConfigurations = {
      kelvin = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          { nixpkgs.overlays = [ neovim-nightly-overlay.overlays.default ]; }
          ./home.nix
        ];
        extraSpecialArgs = {
          username = "kelvin";
          homeDirectory = "/home/kelvin";
        };
      };
      SP13304 = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        modules = [
          { nixpkgs.overlays = [ neovim-nightly-overlay.overlays.default ]; }
          ./work.nix
        ];
        extraSpecialArgs = {
          username = "SP13304";
          homeDirectory = "/Users/SP13304";
        };
      };
    };
  };
}
