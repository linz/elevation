let
  pkgs = import (
    builtins.fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/7541ec60b6f2d38b76e057135bb5942b78d3370c.tar.gz";
      sha256 = "1ndqfddqmfzd8lfq439kwbpm70qdblkdsw22qd16ibns8kq215cz";
    }
  ) {};
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
