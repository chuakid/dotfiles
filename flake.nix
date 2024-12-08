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
        pkgs.buildEnv {
          name = "packages";
          paths = with pkgs; [
            stow
            eza
            bat
            delta
            tmux
            zoxide
            tlrc
            gh
            jq
            go
            python3
            pnpm
            lazygit
            fd
            fzf
          ];
        };
    };
}
