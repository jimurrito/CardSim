# Virtual environment for HighestBidder Elixir/Phoenix development
#
#

{ pkgs ? import <nixpkgs> {} }:
#{ pkgs ? import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") { } }:

pkgs.mkShell {
  name = "phx-nix-shell";
  buildInputs = with pkgs; [
    elixir_1_18
    inotify-tools
    git
    wget
    sysstat
    direnv
    nixpkgs-fmt
    gcc
    zip
    bat
    gh
    inetutils
    fish
  ];

  shellHook = ''
    #
    # Source ENVVARs
    source .env
    # 
    mix Deps.get
    #
    echo "Run 'iex -S mix' to start the Application."
    echo -e "Then run ':observer.start()', if you want to start observer.\n"
    #
    fish
    #
    docker kill "markserv_$(basename "$(pwd)")"
    #
    exit
  '';
}
