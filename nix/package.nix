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
  ...
}:
buildPythonPackage rec {
  inherit src version pname;
  format = "pyproject";
  disabled = pythonOlder "3.8";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-3/aE+RfMohd5GtVB2LtYKuLbIQWP4tlTAzAgHuSruD4=";
  };

  nativeBuildInputs = with rustPlatform; [cargoSetupHook maturinBuildHook];

  buildInputs = lib.optionals stdenv.isDarwin [libiconv];

  pythonImportsCheck = ["${pname}"];

  meta = with lib; {
    description = "A python binding to chardetng";
    license = licenses.asl20;
    maintainers = with maintainers; [emattiza];
  };
}
