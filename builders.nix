{ normalPkgsSrc, surveySrc, compiler, defaultCabalPackageVersionComingWithGhc
}: rec {
  # NOTE: `name` here must match the .cabal file name
  buildStaticPackage = { name, src, extraCabal2nixOptions ? "", args ? { } }:
    let
      staticPackages = buildStaticPackages (haskellPackages: {
        "${name}" = haskellPackages.callCabal2nixWithOptions name src
          extraCabal2nixOptions args;
      });
    in staticPackages.haskellPackages."${name}";

  buildStaticPackages = mkOverrides:
    let
      overlay = self: super: {
        haskell = super.haskell // {
          packages = super.haskell.packages // {
            "${compiler}" = super.haskell.packages."${compiler}".override {
              overrides = hself: hsuper: mkOverrides hself;
            };
          };
        };
      };

      normalPkgs = import normalPkgsSrc { overlays = [ overlay ]; };

    in import surveySrc {
      inherit normalPkgs compiler defaultCabalPackageVersionComingWithGhc;
    };
}

