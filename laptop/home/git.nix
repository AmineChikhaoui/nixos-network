{
  programs.git = {
    enable = true;
    extraConfig = {
      core.editor = "vim";
      color.ui = "auto";
      push.default = "current";
    };
    userName = "Amine Chikhaoui";
    userEmail = "amine@chikhaoui.org";
    ignores = [ "*.o" "*.pyc" "*.pyo" "*~" ];
  };
}
