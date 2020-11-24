build:
	nix-build release.nix

run: build
	result/bin/scheme

repl:
	nix-shell --pure shell.nix --run \
		"cabal repl lib:scheme"

deps:
	cabal2nix . > default.nix

shell:
	nix-shell shell.nix

shell-pure:
	nix-shell --pure shell.nix

external-shell:
	nix-shell external.nix

.PHONY: build run repl shell shell-pure external-shell
