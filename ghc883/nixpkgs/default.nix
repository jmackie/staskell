with (builtins.fromJSON (builtins.readFile ./source.json));
import (builtins.fetchTarball {
  name = "nixpkgs-${rev}";
  url = "https://github.com/nixos/nixpkgs/archive/${rev}.tar.gz";
  inherit sha256;
})
