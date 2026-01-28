{
  description = "Hakyll site with Haskell dev tools (GHC 9.4.8)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        haskell = pkgs.haskell.packages.ghc948;

        tools = [
          # Hakyll site build tools
          haskell.hakyll
          haskell.ghc
          haskell.cabal-install

          pkgs.zlib

          # Haskell development tools
          haskell.hlint
          haskell.fourmolu
          haskell.haskell-language-server
          haskell.implicit-hie
        ];
      in {
        devShells.default = pkgs.mkShell {
          packages = tools;

          shellHook = ''
            echo "📦 Hakyll + Haskell dev shell (GHC 9.4.8)"
            echo "Run: cabal run site build   # build site"
            echo "     cabal run site watch   # auto rebuild"
            echo "     cabal run site preview # local server"
            gen-hie > hie.yaml || true
          '';
        };
      });
}
