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
              ./hosts/common.nix
              ./hosts/common-pc.nix
            ];
          };
          apricot = lib.nixosSystem {
            # Laptop
            system = "x86_64-linux";
            modules = [
              ./hosts/apricot
              ./hosts/common.nix
              ./hosts/common-pc.nix
            ];
          };
          nekopon = lib.nixosSystem {
            # Oracle VPS
            system = "aarch64-linux";
            modules = [
              xkomhotshot.nixosModule
              ./hosts/nekopon
              ./hosts/common.nix
            ];
          };
        };
      };
}
