{
  description = "Flake for Pharo-EDA-Core";

  inputs = rec {
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";
    rydnr-nix-flakes-pharo-vm = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:rydnr/nix-flakes/pharo-vm-12.0.1519.4?dir=pharo-vm";
    };
    rydnr-babymock2 = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rydnr-nix-flakes-pharo-vm.follows = "rydnr-nix-flakes-pharo-vm";
      url = "github:rydnr/babymock2/0.1.3";
    };
    rydnr-object-diff = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rydnr-nix-flakes-pharo-vm.follows = "rydnr-nix-flakes-pharo-vm";
      url = "github:rydnr/object-diff/0.1.3";
    };
    rydnr-pharo-eda-api = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rydnr-pharo-eda-common.follows = "rydnr-pharo-eda-common";
      inputs.rydnr-nix-flakes-pharo-vm.follows = "rydnr-nix-flakes-pharo-vm";
      url = "github:rydnr/pharo-eda-api/0.1.1";
    };
    rydnr-pharo-eda-common = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rydnr-nix-flakes-pharo-vm.follows = "rydnr-nix-flakes-pharo-vm";
      url = "github:rydnr/pharo-eda-common/0.1.2";
    };
    rydnr-pharo-eda-ports = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rydnr-pharo-eda-common.follows = "rydnr-pharo-eda-common";
      inputs.rydnr-nix-flakes-pharo-vm.follows = "rydnr-nix-flakes-pharo-vm";
      url = "github:rydnr/pharo-eda-ports/0.1.1";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        org = "rydnr";
        repo = "pharo-eda-core";
        pname = "${repo}";
        tag = "0.1.1";
        baseline = "PharoEDACore";
        pkgs = import nixpkgs { inherit system; };
        description = "The Core packages: EDA-Application, EDA-Commands, EDA-Events, etc.";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/rydnr/pharo-eda-core";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsVersion = builtins.readFile "${nixpkgs}/.version";
        nixpkgsRelease =
          builtins.replaceStrings [ "\n" ] [ "" ] "nixpkgs-${nixpkgsVersion}";
        shared = import ./nix/shared.nix;
        pharo-eda-core-for = { babymock2, bootstrap-image-name, bootstrap-image-sha256, bootstrap-image-url, object-diff, pharo-eda-api, pharo-eda-common, pharo-eda-ports, pharo-vm }:
          let
            bootstrap-image = pkgs.fetchurl {
              url = bootstrap-image-url;
              sha256 = bootstrap-image-sha256;
            };
            src = ./src;
            pharo-spec-spec = pkgs.fetchgit {
              url = "https://github.com/pharo-spec/spec";
              rev = "790149f2a82e3bc5bf8e3e847468396fabe97cfd";
              sha256 = "sha256-D2nrJAaVe1768nFU7efSIJhnzCexpPCgjOaWMgDP1AY=";
              leaveDotGit = true;
            };
            svenc-neojson = pkgs.fetchgit {
              url = "https://github.com/svenvc/NeoJSON";
              rev = "f54cfb4a931971ed356d1dfde0e135951e82daae";
              sha256 = "sha256-Wqno019dDtLvOiW0mzDovYoKpOiThsa9wwofGe5UE6s=";
              leaveDotGit = true;
            };
          in pkgs.stdenv.mkDerivation (finalAttrs: {
            version = tag;
            inherit pname src;

            strictDeps = true;

            buildInputs = with pkgs; [
              babymock2
              object-diff
              pharo-eda-api
              pharo-eda-common
              pharo-eda-ports
            ];

            nativeBuildInputs = with pkgs; [
              pharo-vm
              pkgs.unzip
            ];

            unpackPhase = ''
              unzip -o ${bootstrap-image} -d image
              cp -r ${src} src
              mkdir -p $out/share/src/${pname}
              cp -r ${svenc-neojson}/repository $out/share/src/neojson
              cp -r ${pharo-spec-spec}/src $out/share/src/spec
            '';

            configurePhase = ''
              runHook preConfigure

              substituteInPlace src/BaselineOfPharoEDACore/BaselineOfPharoEDACore.class.st \
                --replace-fail "github://rydnr/babymock2:main" "tonel://${babymock2}/share/src/babymock2" \
                --replace-fail "github://rydnr/object-diff:main/src" "tonel://${object-diff}/share/src/object-diff" \
                --replace-fail "github://rydnr/pharo-eda-api:main" "tonel://${pharo-eda-api}/share/src/pharo-eda-api" \
                --replace-fail "github://rydnr/pharo-eda-common:main" "tonel://${pharo-eda-common}/share/src/pharo-eda-common" \
                --replace-fail "github://rydnr/pharo-eda-ports:main" "tonel://${pharo-eda-ports}/share/src/pharo-eda-ports" \
                --replace-fail "github://pharo-spec/Spec:Pharo10" "filetree://$out/share/src/spec" \
                --replace-fail "github://svenvc/NeoJSON/repository" "filetree://$out/share/src/neojson"

              # load baseline
              ${pharo-vm}/bin/pharo image/${bootstrap-image-name} eval --save "EpMonitor current disable. NonInteractiveTranscript stdout install. [ Metacello new repository: 'tonel://$PWD/src'; baseline: '${baseline}'; onConflictUseLoaded; load ] ensure: [ EpMonitor current enable ]"

              runHook postConfigure
            '';

            buildPhase = ''
              runHook preBuild

              ${pharo-vm}/bin/pharo image/${bootstrap-image-name} save "${pname}"

              # customize image

              mkdir dist
              mv image/${pname}.* dist/

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall

              mkdir -p $out
              cp -r ${pharo-vm}/bin $out
              cp -r ${pharo-vm}/lib $out
              cp -r dist/* $out/
              cp image/*.sources $out/
              pushd src
              cp -r * $out/share/src/${pname}/
              pushd $out/share/src/${pname}
              ${pkgs.zip}/bin/zip -r $out/share/src.zip .
              popd
              pushd $out/share/src/neojson
              ${pkgs.zip}/bin/zip -r $out/share/neojson.zip .
              popd
              pushd $out/share/src/spec
              ${pkgs.zip}/bin/zip -r $out/share/spec.zip .
              popd
              popd

              runHook postInstall
             '';

            meta = {
              changelog = "https://github.com/rydnr/pharo-eda-core/releases/";
              longDescription = ''
                    Core part of the Pharo EDA stack.
              '';
              inherit description homepage license maintainers;
              mainProgram = "pharo";
              platforms = pkgs.lib.platforms.linux;
            };
        });
      in rec {
        defaultPackage = packages.default;
        devShells = rec {
          default = pharo-eda-core-12;
          pharo-eda-core-12 = shared.devShell-for {
            package = packages.pharo-eda-core-12;
            inherit org pkgs repo tag;
            nixpkgs-release = nixpkgsRelease;
          };
        };
        packages = rec {
          default = pharo-eda-core-12;
          pharo-eda-core-12 = pharo-eda-core-for rec {
            babymock2 = rydnr-babymock2.packages.${system}.babymock2-12;
            bootstrap-image-url = rydnr-nix-flakes-pharo-vm.resources.${system}.bootstrap-image-url;
            bootstrap-image-sha256 = rydnr-nix-flakes-pharo-vm.resources.${system}.bootstrap-image-sha256;
            bootstrap-image-name = rydnr-nix-flakes-pharo-vm.resources.${system}.bootstrap-image-name;
            object-diff = rydnr-object-diff.packages.${system}.object-diff-12;
            pharo-eda-api = rydnr-pharo-eda-api.packages.${system}.pharo-eda-api-12;
            pharo-eda-common = rydnr-pharo-eda-common.packages.${system}.pharo-eda-common-12;
            pharo-eda-ports = rydnr-pharo-eda-ports.packages.${system}.pharo-eda-ports-12;
            pharo-vm = rydnr-nix-flakes-pharo-vm.packages.${system}.pharo-vm;
          };
        };
      });
}
