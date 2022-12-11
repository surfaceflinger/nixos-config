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
    } @ inputs:
    let
      inherit (self) outputs;
    in
    {
      overlays = import ./overlays;

      nixosConfigurations = {
        blahaj = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          # Desktop / Dell Optiplex 9020
          system = "x86_64-linux";
          modules = [ ./nixos/hosts/blahaj ];
        };
        djungelskog = nixpkgs.lib.nixosSystem {
         specialArgs = { inherit inputs outputs; };
          # Laptop / HP Probook 6470b
          system = "x86_64-linux";
          modules = [ ./nixos/hosts/djungelskog ];
        };
        blavingad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
          # VPS @ Oracle Cloud
          system = "aarch64-linux";
          modules = [ ./nixos/hosts/blavingad ];
        };
      };
    };
}
