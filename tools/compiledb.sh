#!/usr/bin/env bash

pwd_portable() {
	if type -t cygpath > /dev/null; then
		cygpath -m "$(pwd)"
	else
		pwd
	fi
}

make --always-make --dry-run all \
	| grep -E -w 'gcc|g++' \
	| grep -w '\-c' \
	| jq -nR "[inputs|{directory:\"$(pwd_portable)\", command:., file: match(\" [^ ]+$\").string[1:]}]" \
	> compile_commands.json

