{
  buildPackages,
  callPackage,
  cargo,
  cargo-nextest,
  clang,
  lib,
  makeSetupHook,
  maturin,
  rust,
  rustc,
  stdenv,
  target ? rust.toRustTargetSpec stdenv.hostPlatform,
}: let
  ccForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}cc";
  cxxForBuild = "${buildPackages.stdenv.cc}/bin/${buildPackages.stdenv.cc.targetPrefix}c++";
  ccForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
  cxxForHost = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++";
  rustBuildPlatform = rust.toRustTarget stdenv.buildPlatform;
  rustTargetPlatform = rust.toRustTarget stdenv.hostPlatform;
  rustTargetPlatformSpec = rust.toRustTargetSpec stdenv.hostPlatform;
in {
  maturinBuildHook = callPackage ({}:
    makeSetupHook {
      name = "maturin-build-hook.sh";
      propagatedBuildInputs = [cargo maturin rustc];
      substitutions = {
        inherit
          ccForBuild
          ccForHost
          cxxForBuild
          cxxForHost
          rustBuildPlatform
          rustTargetPlatform
          rustTargetPlatformSpec
          ;
      };
    }
    ./maturin-build-hook.sh) {};
}
