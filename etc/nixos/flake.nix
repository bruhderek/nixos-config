{
  description = "my nixOS flake";
  
  inputs = {
    nixpkgs = {url = "github:nixos/nixpkgs/nixos-unstable";};
    hyprland = {url = "github:hyprwm/hyprland";};
    home-manager = {
      inputs = {nixpkgs = {follows = "nixpkgs";};};
      url = "github:nix-community/home-manager";
    };
    apple-silicon-support = {url = "github:tpwrules/nixos-apple-silicon";};
  };
  
  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./configuration.nix
          /home/derek/nixos-config
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
        specialArgs = { inherit inputs nixpkgs; };
      };
    };
  };
}
