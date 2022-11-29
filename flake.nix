{
  description = "nat's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xkomhotshot = {
      url = "github:surfaceflinger/xkomhotshot";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , xkomhotshot
    ,
    }:
      with nixpkgs; {
        nixosConfigurations = {
          sparkle = lib.nixosSystem {
            # Desktop / Dell Optiplex 9020
            system = "x86_64-linux";
            modules = [
              ./hosts/sparkle
              ./modules/presets/desktop.nix
              ./modules/user-nat.nix
              ./modules/logitech.nix
              ./modules/virtualization.nix
              ./modules/android.nix
              ./modules/anime4k.nix
            ];
          };
          apricot = lib.nixosSystem {
            # Laptop / HP Probook 6470b
            system = "x86_64-linux";
            modules = [
              ./hosts/apricot
              ./modules/presets/desktop.nix
              ./modules/user-nat.nix
            ];
          };
          nekopon = lib.nixosSystem {
            # VPS @ Oracle Cloud
            system = "aarch64-linux";
            modules = [
              ./hosts/nekopon
              ./modules/presets/server.nix
              ./modules/user-nat.nix
              xkomhotshot.nixosModule
            ];
          };
        };
      };
}
