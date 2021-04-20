{ pkgs ? import <nixpkgs> { } }:
with pkgs;

let
  haskellDeps = ps: with ps; [
    zlib
  ];
  haskellEnv = haskellPackages.ghcWithPackages haskellDeps;
in mkShell {
  buildInputs = [
    haskellEnv
  ];
}