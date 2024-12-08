{
  description = "My Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs, ... }:
    {
      packages."x86_64-linux".default =
        let
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
        in
        pkgs.buildEnv
          {
            name = "packages";
            paths = import ./common.nix pkgs;
          };
      packages."x86_64-darwin".default =
        let
          pkgs = nixpkgs.legacyPackages."x86_64-darwin";
        in
        pkgs.buildEnv {
          name = "packages";
          paths = import ./common.nix pkgs;
        };
    };
}
