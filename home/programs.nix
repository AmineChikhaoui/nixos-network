{ pkgs, lib, ... }:
with pkgs;
let
  shells = [
    zsh oh-my-zsh alacritty kitty fish
    starship
  ];
  editors = [
    # editors
    neovim emacs /* jetbrains.idea-community */
    obsidian
  ];
  networking = [
    # networking
    wget bind inetutils mtr networkmanagerapplet tcpdump
    wireshark dogdns
    openvpn
  ];
  security = [
    # password managers & security
    gnupg pass age sops
    agebox
  ];
  vcs = [
    # VCS
    git mercurial gh
  ];
  toolchains = [
    # Languages/Compilers/Debuggers, ...

    # GCC toolchain
    gnumake gcc gdb rr binutils

    ## Java
    #openjdk

    ## Haskell
    ghc

    # NodeJS
    nodejs yarn yarn2nix

    ## Zig
    zig zls

    ## Python
    python
    (python3.withPackages(ps: [
      ps.python-lsp-server
      ps.pyls-isort ps.python-lsp-black
    ]))

    ## Rust
    rustup

    ## Golang
    go_1_19 gopls delve

    ## ConfigLangs
    dhall dhall-json
    cue go-jsonnet
    dyff
  ];
  deployment = [
    # deployment tools
    nixopsUnstable terraform flyctl terraform-docs

    docker-compose kubernetes-helm

    # Cloud
    awscli azure-cli ssm-session-manager-plugin

    # uncategorized
    shfmt arandr
    apk-tools proot bubblewrap
    ripgrep  patchelf  sqlite-interactive lsof htop
    vlc bc jq yq smartmontools elfutils openssl cscope pigz
    scrot perf-tools trace-cmd pinentry xclip xsel usbutils sysstat fd fzf
    bat
    criu i3status-rust direnv poetry google-cloud-sdk-gce nasm ncdu
    rofimoji
    fq
    niv
    tree
  ];
in
  {
    home.packages = lib.flatten [
      deployment
      shells
      editors
      networking
      security
      vcs
      toolchains
      firefox
      borgbackup
    ];
  }
