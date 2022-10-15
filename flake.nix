{
  description = "nat's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xkomhotshot.url = "github:surfaceflinger/xkomhotshot";
  };

  outputs = {
    self,
    nixpkgs,
    xkomhotshot,
  }:
    with nixpkgs; {
      nixosConfigurations = {
        sparkle = lib.nixosSystem {
          # Desktop
          system = "x86_64-linux";
          modules = [
            ./hosts/sparkle
          ];
        };
        apricot = lib.nixosSystem {
          # Laptop
          system = "x86_64-linux";
          modules = [
            ./hosts/apricot
          ];
        };
        nekopon = lib.nixosSystem {
          # Oracle VPS
          system = "aarch64-linux";
          modules = [
            xkomhotshot.nixosModule
            ./hosts/nekopon
          ];
        };
      };
    };
}
