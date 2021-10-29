{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    unstablepkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    hydra.url = "github:NixOS/hydra";
    home-manager.url = "github:nix-community/home-manager/release-21.05";

    # Secrets management
    sops-nix.url = github:Mic92/sops-nix;
  };

  outputs =
    flakes @ {
      self, nixpkgs, unstablepkgs, hydra, home-manager, sops-nix
    }:

    let
      unstablePkgs = system:
        import unstablepkgs {
          inherit system;
          config.allowUnfree = true;
        };

      unstablex86Pkgs = unstablePkgs "x86_64-linux";
      unstableAarch64Pkgs = unstablePkgs "aarch64-linux";
    in
    {
      nixosConfigurations =
        {
          nixos =
            nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              modules = [
                (import ./laptop/configuration.nix unstablex86Pkgs)
                (
                  { environment.systemPackages = [
                      home-manager.defaultPackage.x86_64-linux
                    ];
                  }
                )
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.amine = import ./laptop/home.nix;
                }
                sops-nix.nixosModules.sops {
                  sops.defaultSopsFile = ./secrets.yaml;
                  sops.age.keyFile = "/home/amine/.config/sops/age/keys.txt";
                }
            ];
          };

          linode =
            nixpkgs.lib.nixosSystem
            {
              system = "x86_64-linux";
              modules = [
                (import ./linode/configuration.nix unstablex86Pkgs)
                # sops-nix.nixosModule {
                #   sops.defaultSopsFile = ./secrets.yaml;
                #   sops.age.keyFile = "/var/lib/sops-nix/key.txt";
                #   sops.age.generateKey = true;
                # }
              ];
            };

          # Oracle Cloud free tier aarch64 box
          monitoring =
            nixpkgs.lib.nixosSystem
            {
              system = "aarch64-linux";
              modules = [
                (import ./monitoring/configuration.nix unstableAarch64Pkgs)
                sops-nix.nixosModules.sops {
                  sops.defaultSopsFile = ./secrets.yaml;
                  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
                  sops.age.generateKey = true;
                }
              ];
            };

        };
    };
}
