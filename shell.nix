let
  pkgs = import (builtins.fetchTarball {
    name = "nixos-unstable-2024-09-17";
    url = "https://github.com/nixos/nixpkgs/archive/345c263f2f53a3710abe117f28a5cb86d0ba4059.tar.gz";
    sha256 = "1llzyzw7a0jqdn7p3px0sqa35jg24v5pklwxdybwbmbyr2q8cf5j";
  }) { };
in
pkgs.mkShell {
  packages = [
    pkgs.alejandra
    pkgs.bashInteractive
    pkgs.gdal
    pkgs.gitFull
    pkgs.nodejs
    pkgs.s5cmd
  ];
}
