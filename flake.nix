{
  description = "PurpleExplorer – cross-platform Azure Service Bus explorer built with Avalonia UI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem
      [
        "aarch64-darwin"
        "x86_64-linux"
      ]
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; };

          purpleExplorer = pkgs.buildDotnetModule {
            pname = "PurpleExplorer";
            version = "0.1.0";

            src = ./.;

            projectFile = "PurpleExplorer/PurpleExplorer.csproj";

            nugetDeps = ./deps.json;

            dotnet-sdk = pkgs.dotnetCorePackages.sdk_8_0;
            dotnet-runtime = pkgs.dotnetCorePackages.runtime_8_0;

            # (Directory.Build.targets in the repo root overrides the Avalonia telemetry target
            # which crashes in the Nix sandbox - see that file for details.)

            # Avalonia requires the desktop runtime
            runtimeDeps = with pkgs; lib.optionals stdenv.isLinux [
              fontconfig
              xorg.libX11
              xorg.libXext
              xorg.libXrandr
              xorg.libXi
              xorg.libXcursor
              xorg.libXrender
              libGL
              libICE
              libSM
            ];

            meta = {
              description = "Cross-platform desktop tool for managing Azure Service Bus";
              homepage = "https://github.com/telstrapurple/PurpleExplorer";
              license = pkgs.lib.licenses.mit;
              mainProgram = "PurpleExplorer";
              platforms = [
                "aarch64-darwin"
                "x86_64-linux"
              ];
            };
          };
        in
        {
          packages = {
            default = purpleExplorer;
            purpleExplorer = purpleExplorer;
          };

          apps = {
            default = {
              type = "app";
              program = "${purpleExplorer}/bin/PurpleExplorer";
            };
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              dotnetCorePackages.sdk_8_0
            ];

            shellHook = ''
              echo "PurpleExplorer dev shell"
              echo "  dotnet run --project PurpleExplorer/PurpleExplorer.csproj"
            '';
          };
        }
      );
}
