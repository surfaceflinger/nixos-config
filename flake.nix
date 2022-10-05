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
            # Desktop
            system = "x86_64-linux";
            modules = [
              ./hosts/sparkle
              ./hosts/common-minimal.nix
              ./hosts/common-standard.nix
              ./hosts/common-desktop.nix
            ];
          };
          apricot = lib.nixosSystem {
            # Laptop
            system = "x86_64-linux";
            modules = [
              ./hosts/apricot
              ./hosts/common-minimal.nix
              ./hosts/common-standard.nix
              ./hosts/common-desktop.nix
            ];
          };
          nekopon = lib.nixosSystem {
            # VPS @ Oracle Cloud
            system = "aarch64-linux";
            modules = [
              ./hosts/nekopon
              ./hosts/common-minimal.nix
              ./hosts/common-standard.nix
              xkomhotshot.nixosModule
            ];
          };
        };
      };
}
