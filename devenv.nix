{ pkgs, lib, config, inputs, ... }:

{
  # Environment name
  name = "Nerves Dev Shell";

  # Environment variables (static values only)
  env = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    EDITOR = "vim";

    # NPM/Hex registry configuration
    NPM_CONFIG_REGISTRY = "https://nexus.gsmlg.net/repository/npm-org/";
    HEX_MIRROR = "https://nexus.gsmlg.net/repository/hex-pm/";
    HEX_CDN = "https://nexus.gsmlg.net/repository/hex-pm/";
  };

  # Dependencies
  packages = with pkgs; [
    # Nix formatter
    alejandra

    # Development tools
    openapi-generator-cli
    figlet

    # Nerves build dependencies
    libmnl
    autoconf
    automake
    curl
    fwup
    git
    squashfsTools
    pkg-config
    xz

    # Frontend tools
    esbuild
    tailwindcss
  ];

  # Shell hook - runs when entering the dev shell
  enterShell = ''
    figlet -w 120 -f starwars Nerves
    figlet -w 120 -f starwars Dev Shell
  '';
}
