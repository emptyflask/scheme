# Scheme in Haskell

Following the guide at https://en.wikibooks.org/wiki/Write_Yourself_a_Scheme_in_48_Hours/Parsing

Also see https://jakewheat.github.io/intro_to_parsing/

## Running

This is configured to build with [Nix](https://nixos.org/download.html).

```
make deps # if cabal file has been updated

make
./result/bin/scheme '(+ 1 2)'
```
