{
  nixConfig = {
    extra-substituters = "https://nexus.gsmlg.net/repository/nix-cache/";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    systems.url = "github:nix-systems/default";
  };

  outputs = {
    systems,
    nixpkgs,
    ...
  } @ inputs: let
    # the project root in nix store
    PROJECT_ROOT = builtins.toString ./.;

    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems) (
        system:
          f {
            pkgs = nixpkgs.legacyPackages.${system};
          }
      );
  in {

    formatter = eachSystem (opts:
    let
      pkgs = opts.pkgs;
    in {
      default = pkgs.alejandra;
    });

    devShells = eachSystem (opts:
    let
      pkgs = opts.pkgs;
    in {
      default = pkgs.mkShell {
        name = "Nerves Dev Shell";

        LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

        buildInputs = with pkgs; [
          alejandra
          openapi-generator-cli
          figlet
          libmnl

          autoconf
          automake
          curl
          fwup
          git
          squashfsTools
          pkg-config
          xz

          asdf

          esbuild
          tailwindcss
        ];

        shellHook = ''
        figlet -w 120 -f starwars Nerves
        figlet -w 120 -f starwars Dev Shell

        export EDITOR=vim

        export NPM_CONFIG_PREFIX=$HOME/.local/share/npm
        export NPM_CONFIG_REGISTRY=https://nexus.gsmlg.net/repository/npm-org/

        export MIX_HOME=$HOME/.local/share/mix_nerves
        export HEX_MIRROR=https://nexus.gsmlg.net/repository/hex-pm/
        export HEX_CDN=https://nexus.gsmlg.net/repository/hex-pm/

        export BROWSERSLIST_IGNORE_OLD_DATA=true

        export ASDF_DATA_DIR=$HOME/.asdf

        export PATH="$ASDF_DATA_DIR/shims:$HOME/.local/share/galaxy-pub-cache/bin:$PATH"

        '';
      };
    });
  };
}


