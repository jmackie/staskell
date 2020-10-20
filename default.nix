{
  ghc883 = (import ./builders.nix {
    normalPkgsSrc = ./ghc883/nixpkgs/patched.nix;
    surveySrc = ./ghc883/static-haskell-nix/survey.nix;
    compiler = "ghc883";
    defaultCabalPackageVersionComingWithGhc = "Cabal_3_2_0_0";
  }) // {
    nixpkgs = ./ghc883/nixpkgs;
  };
}
