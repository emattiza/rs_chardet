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
  disabled = pythonOlder "3.6";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-phmxYqJ7fWZHJH1BI7XEymqXK+Mchd37scEGTy/mLZk=";
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
