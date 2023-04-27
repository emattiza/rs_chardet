{
  src,
  version,
  pname,
  lib,
  stdenv,
  pythonOlder,
  buildPythonPackage,
  rustPlatform,
  libiconv,
  pkgs,
  ...
}: let
  customHook = pkgs.callPackage ./customBuildHook.nix {};
  customBuildHook = customHook.maturinBuildHook;
in
  buildPythonPackage rec {
    inherit src version pname;
    format = "pyproject";
    disabled = pythonOlder "3.6";

    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${pname}-${version}";
      hash = "sha256-1+CO8Q90+9F2qDO38DYhb30Hi5GO+QI1z/DvXuSloIM=";
    };

    nativeBuildInputs = with rustPlatform; [cargoSetupHook customBuildHook];

    buildInputs = lib.optionals stdenv.isDarwin [libiconv];

    pythonImportsCheck = ["${pname}"];

    meta = with lib; {
      description = "A python binding to chardetng";
      license = licenses.asl20;
      maintainers = with maintainers; [emattiza];
    };
  }
