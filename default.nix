{ mkDerivation, base, containers, parsec, stdenv }:
mkDerivation {
  pname = "scheme";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base containers parsec ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
