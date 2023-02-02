{ pkgs, ... }:
{
  home.packages = [
    pkgs.vscode
  ];
  home.stateVersion = "22.05";

  imports = [
    ./git.nix
    ./vim.nix
    ./programs.nix
    # ./home/vscode.nix
  ];
}
