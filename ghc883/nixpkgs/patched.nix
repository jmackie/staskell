# Patch is required for static builds on GHC 8.8.3, see:
# https://github.com/NixOS/nixpkgs/issues/85924
let
  source = with (builtins.fromJSON (builtins.readFile ./source.json));
    builtins.fetchTarball {
      name = "nixpkgs-${rev}";
      url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
      inherit sha256;
    };

  bootstrap = import source { };
  applyPatches = name: src: patches:
    bootstrap.runCommand name { inherit src patches; } ''
      set -eou pipefail
      cp -r $src $out
      chmod -R u+w $out
      for patch in $patches; do
        echo "Applying patch $patch"
        patch -d "$out" -p1 < "$patch"
      done
    '';
in import
(applyPatches "patched-nixpkgs" source [ ./nixpkgs-revert-ghc-bootstrap.patch ])
