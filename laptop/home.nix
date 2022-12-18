{ pkgs, ... }:
{
  home.packages = [
    pkgs.vscode
  ];
  home.stateVersion = "22.05";

  imports = [
    ./home/git.nix
    ./home/vim.nix
    # ./home/vscode.nix
  ];
}
