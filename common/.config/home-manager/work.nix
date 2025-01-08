{ config, pkgs, username, homeDirectory, ... }:

{
  imports = [ ./common.nix ];
  home.username = username;
  home.homeDirectory = homeDirectory;
  
  home.packages = with pkgs; [
    yarn
    bun
    python311
  ];

# Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
