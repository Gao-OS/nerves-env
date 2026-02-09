{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  pkgs-stable = import inputs.nixpkgs-stable {system = pkgs.stdenv.system;};
in {
  # Environment name
  name = "Nerves Dev Shell";

  # Environment variables
  env = {
    LOCALE_ARCHIVE = "${pkgs-stable.glibcLocales}/lib/locale/locale-archive";
    EDITOR = "nvim";

    # NPM/Hex registry configuration
    NPM_CONFIG_REGISTRY = "https://nexus.gsmlg.net/repository/npm-org/";
    HEX_MIRROR = "https://nexus.gsmlg.net/repository/hex-pm/";
    HEX_CDN = "https://nexus.gsmlg.net/repository/hex-pm/";

    # Nerves environment
    ERL_AFLAGS = "-kernel shell_history enabled";
  };

  # Erlang/Elixir via devenv languages
  languages.erlang = {
    enable = true;
    package = pkgs-stable.beam27Packages.erlang;
  };

  languages.elixir = {
    enable = true;
    package = pkgs-stable.beam27Packages.elixir;
  };

  languages.javascript = {
    enable = true;
    pnpm.enable = true;
    bun.enable = true;
    bun.package = pkgs-stable.bun;
  };

  # Dependencies
  packages = with pkgs-stable; [
    # Nix formatter
    alejandra

    # Development tools
    openapi-generator-cli
    figlet
    lolcat

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
    coreutils
    gawk
    gnused
    gnugrep

    # SSL/crypto for mix deps
    openssl

    # For NIF compilation
    gcc
    gnumake

    # SSH for firmware deployment
    openssh

    # Frontend tools
    tailwindcss_4
  ];

  # Shell hook - runs when entering the dev shell
  enterShell = ''
    # Set MIX_HOME to current directory
    export MIX_HOME="$DEVENV_ROOT/.mix"
    export HEX_HOME="$DEVENV_ROOT/.hex"
    export PATH="$MIX_HOME/bin:$MIX_HOME/escripts:$PATH"

    # Nerves artifacts in current directory
    export NERVES_DL_DIR="$DEVENV_ROOT/.nerves/dl"
    export NERVES_ARTIFACTS_DIR="$DEVENV_ROOT/.nerves/artifacts"

    # Ensure directories exist
    mkdir -p "$MIX_HOME" "$HEX_HOME" "$NERVES_DL_DIR" "$NERVES_ARTIFACTS_DIR"

    # Ensure mix and hex are installed
    if [ ! -f "$MIX_HOME/archives/hex"* ] 2>/dev/null; then
      echo "Installing local hex and rebar..."
      mix local.hex --force --if-missing
      mix local.rebar --force --if-missing
    fi

    figlet -w 120 -f starwars Nerves | lolcat
    figlet -w 120 -f starwars Dev Shell | lolcat

    echo ""
    echo "Erlang/OTP: $(erl -eval 'io:format("~s", [erlang:system_info(otp_release)]), halt().' -noshell)"
    echo "Elixir: $(elixir --version | grep Elixir)"
    echo "Nerves artifacts: $NERVES_ARTIFACTS_DIR"
    echo ""
  '';
}
