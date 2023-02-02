{ pkgs, ... }:
let

  extensions =
    (with pkgs.vscode-extensions; [
      matklad.rust-analyzer
      vadimcn.vscode-lldb
      serayuzgur.crates
      ms-vscode.cpptools
    ])
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "Nix";
        publisher = "bbenoist";
        version = "1.0.1";
        sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
      }
      {
        name = "better-toml";
        publisher = "bungcip";
        version = "0.3.2";
        sha256 = "sha256-g+LfgjAnSuSj/nSmlPdB0t29kqTmegZB5B1cYzP8kCI=";
      }
      {
        name = "terraform";
        publisher = "hashicorp";
        version = "2.11.0";
        sha256 = "sha256-Xo+9YtDEcNCaRK3dsFtzqBk8dKyfSaQ7LoGsUYbyDXM=";
      }
#      {
#        name = "rust";
#        publisher = "rust-lang";
#        version = "0.7.8";
#        sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
#      }
      { name  = "linkerscript";
        publisher = "zixuanwang";
        version = "1.0.2";
        sha256 = "sha256-J6j4tXJ+gQWGJnMiqoIqJT2kGs/m8Njjm9pX9NCvJWc=";
      }
      {
        name = "zig";
        publisher = "tiehuis";
        version = "0.2.5";
        sha256 = "sha256-P8Sep0OtdchTfnudxFNvIK+SW++TyibGVI9zd+B5tu4=";
      }
      {
        name = "zls-vscode";
        publisher = "augusterame";
        version = "1.0.4";
        sha256 = "sha256-Mb2RFRjD6+iw+ZaoMc/O3FU128bl9pGg07jPDDxrZtk=";
      }
      {
        name = "go";
        publisher = "golang";
        version = "0.20.1";
        sha256 = "sha256-UjGaePjYceLdkf2yrxkVy6ht2aStJ5wklguKe/Z8HUI=";
      }
      {
        name = "vim";
        publisher = "vscodevim";
        version = "1.18.5";
        sha256 = "sha256-hJbd+tkWl7rOhV7kBdmfv2BxYWxPD0KmU8GRvCasdTE=";
      }
      {
        name = "dhall-lang";
        publisher = "dhall";
        version = "0.0.4";
        sha256 = "sha256-7vYQ3To2hIismo9IQWRWwKsu4lXZUh0Or89WDLMmQGk=";
      }
      {
        name = "vscode-dhall-lsp-server";
        publisher = "dhall";
        version = "0.0.4";
        sha256 = "sha256-WopWzMCtiiLrx3pHNiDMZYFdjS359vu3T+6uI5A+Nv4=";
      }
      {
        publisher = "ms-vscode";
        name = "makefile-tools";
        version = "0.2.2";
        sha256 = "sha256-f3DOpYQgozNk7u/8UJIh9PNBis6Ag9Z06vFkMGeUdhU=";
      }
    ];

  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };

in {
  home.packages = [ pkgs.vscode ];
}
