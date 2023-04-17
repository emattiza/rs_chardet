{
  # Build Pyo3 package
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [inputs.rust-overlay.overlays.default];
      };
      project_name = "rs_chardet";
      project_version = "0.1.0";
      python_version = pkgs.python310;
      buildPythonPackage = pkgs.python310Packages.buildPythonPackage;
    in rec {
      packages = {
        # A python version with the library installed
        default = packages.pythonpkg;
        pythonpkg = python_version.withPackages (ps: [
          lib.python_module
        ]);
      };
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.rustc
          pkgs.rust-analyzer
          pkgs.cargo
          packages.pythonpkg
        ];
      };
      lib = {
        # To use in other builds with the "withPackages" call
        python_module = pkgs.callPackage ./nix/package.nix {
          inherit buildPythonPackage;
          pythonOlder = python_version.pythonOlder;
          python = python_version;
          src = ./.;
          version = project_version;
          pname = project_name;
        };
      };
    });
}
