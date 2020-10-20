let
  staskell = import ../..;
  pkgs = import staskell.ghc883.nixpkgs { };
in pkgs.mkShell { buildInputs = [ pkgs.cabal-install ]; }

