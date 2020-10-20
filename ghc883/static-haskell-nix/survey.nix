{ ... }@args:
let
  static-haskell-nix =
    with (builtins.fromJSON (builtins.readFile ./source.json));
    builtins.fetchTarball {
      name = "static-haskell-nix-${rev}";
      url = "https://github.com/nh2/static-haskell-nix/archive/${rev}.tar.gz";
      inherit sha256;
    };

in import "${static-haskell-nix}/survey" args
