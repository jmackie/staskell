let staskell = import ../..;
in staskell.ghc883.buildStaticPackage {
  name = "hello-staskell";
  src = ./.;
}
