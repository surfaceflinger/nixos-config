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
          ./hosts/desktop
        ];
      };
      apricot = nixpkgs.lib.nixosSystem {
        # Laptop
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop
        ];
      };
    };
  };
}