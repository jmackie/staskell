#!/usr/bin/env bash

set -euo pipefail
shopt -s inherit_errexit
IFS=$'\n\t'

main() {
  for example in examples/*; do
    pushd "$example"

    # Build binaries
    nix-build -o result

    # Check binaries are static
    # (ldd exits with non-zero if the exectuable isn't dynamic)
    find result/bin -executable -exec sh -c 'bin="$1"; ldd "$bin" && echo "$bin" not static' _ {} \;

    # Check that shell.nix works
    nix-shell --run 'echo shell works'
    popd
  done
}

main "$@"
