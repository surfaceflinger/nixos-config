{
  description = "nat's nixos hosts configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      sparkle = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
        ];
      };
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix
        ];
      };
      apricot = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/configuration.nix
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop/configuration.nix
        ];
      };
    };
  };
}
