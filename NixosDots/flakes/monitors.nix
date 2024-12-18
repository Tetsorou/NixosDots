{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    split-monitor-workspaces,
    ...
  }: let
    system = "x86_64-linux";
    #        ↑ Swap it for your system if needed
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      yourHostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # ...
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.yourUsername = {
                wayland.windowManager.hyprland = {
                  # ...
                  plugins = [
                    split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
                  ];
                  # ...
                };
              };
            };
          }
        ];
        # ...
      };
    };
  };
}