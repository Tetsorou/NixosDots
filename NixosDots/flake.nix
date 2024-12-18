{
  description = "A simple flake for an atomic system";
  
 # imports = [
#  ./flakes
 # ];


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    nixvim.url = "github:Sly-Harvey/nixvim";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    /* Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    }; */
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprland.url = "github:hyprwm/Hyprland";
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland"; # <- make sure this line is present for the plugin to work as intended
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickemu = {
      url = "https://flakehub.com/f/quickemu-project/quickemu/4.9.6.tar.gz";
    };
  };

  outputs = {self, nixpkgs, home-manager, quickemu, split-monitor-workspaces,...} @ inputs: let
    # User configuration
    username = "tetsorou"; # WARNING REPLACE THIS WITH YOUR USERNAME IF YOU ARE MANUALLY INSTALLING WITHOUT THE SCRIPT
    terminal = "alacritty"; # or kitty

    # System configuration
    locale = "en_US.UTF-8"; # REPLACE THIS WITH YOUR LOCALE
    timezone = "America/Managua"; # REPLACE THIS WITH YOUR TIMEZONE
    hostname = "tetsorou"; # CHOOSE A HOSTNAME HERE (default is fine)

    arguments = {
      inherit
      username
      terminal
      system
      locale
      timezone
      hostname;
    };

    system = "x86_64-linux"; # most users will be on 64 bit pcs (unless yours is ancient)
    
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      Default = lib.nixosSystem {
        inherit system;
        specialArgs = (arguments //
        { inherit inputs; }) // inputs; # Expose all inputs and arguments
        modules = [
          ./hosts/Default/configuration.nix
        ];
      };
      Desktop = lib.nixosSystem {
        inherit system;
        specialArgs = (arguments //
        { inherit inputs; hostname = "NixOS-Desktop"; }) // inputs; # Expose all inputs and arguments
        modules = [
          ./hosts/Desktop/configuration.nix
        ];
      };
      Laptop = lib.nixosSystem {
        inherit system;
        specialArgs = (arguments //
        { inherit inputs; hostname = "NixOS-Laptop"; }) // inputs; # Expose all inputs and arguments
        modules = [
          ./hosts/Laptop/configuration.nix
        ];
      };
      Iso = lib.nixosSystem { # Build the iso with the build-iso command. (cpu intensive)
        inherit system;
        specialArgs = (arguments //
        { inherit inputs; hostname = "NixOS-Portable"; }) // inputs; # Expose all inputs and arguments
        modules = [
          ./hosts/ISO/configuration.nix
        ];
      };
    };
  };
}
