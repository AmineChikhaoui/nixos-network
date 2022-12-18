{
  programs.git = {
    enable = true;
    extraConfig = {
      core.editor = "vim";
      color.ui = "auto";
      push.default = "current";
      # git config --global commit.gpgsign true  # Sign all commits
      # git config --global tag.gpgsign true  # Sign all tags
      # git config --global gpg.x509.program gitsign  # Use gitsign for signing
      # git config --global gpg.format x509  # gitsign expects x509 args
      # commit.gpgsign = true;
      # tag.gpgsign = true;
      # gpg.x509.program = "gitsign";
      # gpg.format = "x509";
    };
    aliases = {
    };
    userName = "Amine Chikhaoui";
    userEmail = "amine@chikhaoui.org";
    ignores = [ "*.o" "*.pyc" "*.pyo" "*~" ];
  };
}
