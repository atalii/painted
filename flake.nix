{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in {
      defaultPackage.x86_64-linux = let inner = pkgs.buildGoModule {
        name = "inner";
        version = "v0.1.3";

        src = builtins.filterSource
          (path: type: baseNameOf path != "contrib")
          ./.;

	vendorSha256 = "sha256-yniIybh0nFy9S3jkBW8ey2mIOqHjUUIWuRIkWn9StnY=";
      }; in pkgs.stdenv.mkDerivation {
        name = "painted";
        version = "v0.1.3";

        src = ./.;

        installPhase = ''
          mkdir -p $out
          cp -r ${inner}/* $out/

          mkdir -p $out/share/man/man1
          cp painted.1 $out/share/man/man1
        '';

        dontBuild = true;
        dontConfigure = true;
      };

      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = [ pkgs.go pkgs.libnotify ];
        shellHook = ''
          ln -sf ../../.githooks/pre-commit .git/hooks/pre-commit
        '';
      };
    };
}
