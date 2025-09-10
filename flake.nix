{
  description = "C's Nix Packages";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.url = "github:nix-systems/default-linux";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    git-hooks,
    ...
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      inherit (nixpkgs) lib;
      scenics = import ./pkgs {
        inherit pkgs lib;
      };
      git-hook-check = git-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          deadnix.enable = true;
          statix.enable = true;
          flake-checker.enable = true;

          end-of-file-fixer.enable = true;
          check-merge-conflicts.enable = true;
          trim-trailing-whitespace.enable = true;

          actionlint.enable = true;

          check-yaml.enable = true;
          check-toml.enable = false;
          check-json.enable = false;

          typos.enable = true;

          shellcheck.enable = true;
          shfmt.enable = true;
        };
      };
    in {
      packages = scenics;

      checks = {
        git-hook = git-hook-check;
      };

      devShells.default = pkgs.mkShell {
        inherit (git-hook-check) shellHook;
        buildInputs = with pkgs; [nix-init alejandra];
      };

      formatter = pkgs.alejandra;
    })
    // {
      overlays.default = import ./overlay.nix;
    };
}
