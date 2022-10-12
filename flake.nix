{
  description = "nat's nixos configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    nixosConfigurations = {
      sparkle = nixpkgs.lib.nixosSystem {
        # Desktop
        system = "x86_64-linux";
        modules = [
          ./hosts/sparkle
        ];
      };
      apricot = nixpkgs.lib.nixosSystem {
        # Laptop
        system = "x86_64-linux";
        modules = [
          ./hosts/apricot
        ];
      };
      nekopon = nixpkgs.lib.nixosSystem {
        # Oracle VPS
        system = "aarch64-linux";
        modules = [
          ./hosts/nekopon
        ];
      };
    };
  };
}
