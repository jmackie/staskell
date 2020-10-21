# `staskell`

![.github/workflows/ci.yaml](https://github.com/jmackie/staskell/workflows/.github/workflows/ci.yaml/badge.svg)
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

Quickly and easily write static Haskell executables with help from [Nix](https://nixos.org/).

Essentially just some high-level helpers on top of [`static-haskell-nix`](https://github.com/nh2/static-haskell-nix)
and a ready baked [cachix](https://staskell.cachix.org) so you can get going straight away.

Currently only GHC 8.8.3 is supported --- open an issue if you want other versions.

## How to use it

First write your Haskell thing (i.e. `Main.hs`, `haskell-thing.cabal`, etc).

Then add a `default.nix`:

```nix
let
  staskell = import (builtins.fetchFromGitHub {
    owner = "jmackie";
    repo = "staskell";
    rev = "PICK-ONE";
    sha256 = "FILL-THIS-IN";
  });
in
staskell.ghc883.buildStaticPackage {
  name = "haskell-thing";
  # Might want to `gitignore.nix` this...
  # https://github.com/hercules-ci/gitignore.nix
  src = ./.;
}
```

Use the staskell cache:

```bash
$ cachix use staskell
```

And finally `nix-build` your static executable 🎉

## CI example

Commit a [workflow](https://docs.github.com/en/free-pro-team@latest/actions/learn-github-actions/introduction-to-github-actions) like the following:

```yaml
name: CI
on: push
jobs:
  build-static-exe:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v2

      - name: Install Nix
        uses: cachix/install-nix-action@v8

      - name: Setup Cachix
        run: |
          nix-env -iA cachix -f https://cachix.org/api/v1/install
          cachix use staskell

      - name: Build
        run: nix-build

      # Might want to also create an artifact from ./result/bin/*
```
