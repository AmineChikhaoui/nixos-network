{ pkgs, ... }:
{
  home.packages = [
    pkgs.vscode
  ];

  imports = [
    ./home/git.nix
    ./home/vim.nix
    # ./home/vscode.nix
  ];
}
