{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    unstablepkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # hydra.url = "github:NixOS/hydra";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs =
    flakes@{ self, nixpkgs, unstablepkgs, nix-ld, home-manager, sops-nix }:

    let
      unstablePkgs = system:
        import unstablepkgs {
          inherit system;
          config.allowUnfree = true;
        };

      unstablex86Pkgs = unstablePkgs "x86_64-linux";
      unstableAarch64Pkgs = unstablePkgs "aarch64-linux";
    in {
      nixosConfigurations = {
        macbook= nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./laptop/configuration.nix unstablex86Pkgs)
            ({
              environment.systemPackages =
                [ home-manager.defaultPackage.x86_64-linux ];
            })
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.amine = import ./laptop/home.nix;
            }
            sops-nix.nixosModules.sops
            {
              sops.defaultSopsFile = ./secrets.yaml;
              sops.age.keyFile = "/home/amine/.config/sops/age/keys.txt";
            }
            nix-ld.nixosModules.nix-ld
          ];
        };
        vm = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./modules/vmware-guest.nix
            ./hardware/vm.nix
            (import ./vms/linux-aarch64/configuration.nix unstableAarch64Pkgs)
            ({
              environment.systemPackages =
                [ home-manager.defaultPackage.aarch64-linux ];
            })
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.amine = import ./home/home.nix;
            }
            nix-ld.nixosModules.nix-ld
            #sops-nix.nixosModules.sops
            #{
            #  sops.defaultSopsFile = ./secrets.yaml;
            #  sops.age.keyFile = "/home/amine/.config/sops/age/keys.txt";
            #}
          ];
        };


        linode = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            (import ./linode/configuration.nix unstablex86Pkgs)
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.amine = import ./home/home.nix;
            }
             sops-nix.nixosModule {
               sops.defaultSopsFile = ./secrets.yaml;
               sops.age.keyFile = "/var/lib/sops-nix/key.txt";
               sops.age.generateKey = true;
             }
          ];
        };

        # Oracle Cloud free tier aarch64 box
        dev = unstablepkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            (import ./dev/configuration.nix unstableAarch64Pkgs)
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.amine = import ./laptop/home.nix;
            }
            sops-nix.nixosModules.sops
            {
              sops.defaultSopsFile = ./secrets.yaml;
              sops.age.keyFile = "/var/lib/sops-nix/key.txt";
              sops.age.generateKey = true;
            }
          ];
        };

        # home raspberry pi 4
        atl-rpi4 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            (import ./atl-rpi4/configuration.nix unstableAarch64Pkgs)
            sops-nix.nixosModules.sops
            {
              sops.defaultSopsFile = ./secrets.yaml;
              sops.age.keyFile = "/var/lib/sops-nix/key.txt";
              sops.age.generateKey = true;
            }
          ];
        };

      };
    };
}
