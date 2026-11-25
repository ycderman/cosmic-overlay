#!/usr/bin/env bash
# Build "<pn>-<pv>.full.tar.zst": upstream tag + vendored Cargo dependencies.
# Usage: vendor.sh <pn> <upstream-repo> <tag> <pv> <outdir> [owner]
set -euo pipefail
pn=$1 repo=$2 tag=$3 pv=$4 out=$5 owner=${6:-pop-os}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$out"

if [[ $tag =~ ^[0-9a-f]{40}$ ]]; then
	git init --quiet "$work/src"
	git -C "$work/src" fetch --quiet --depth 1 "https://github.com/${owner}/${repo}.git" "$tag"
	git -C "$work/src" checkout --quiet FETCH_HEAD
	git -C "$work/src" submodule --quiet update --init --recursive --depth 1
else
	git clone --quiet --depth 1 --branch "$tag" --recurse-submodules --shallow-submodules \
		"https://github.com/${owner}/${repo}.git" "$work/src"
fi
rm -rf "$work/src/.git"
find "$work/src" -name .git -prune -exec rm -rf {} +

if [[ -f $work/src/Cargo.toml ]]; then
	(
		cd "$work/src"
		mkdir -p .cargo
		cfg=$(cargo vendor --locked --versioned-dirs vendor)
		printf '\n# Added by depos-cosmic vendor.sh\n%s\n' "$cfg" >> .cargo/config.toml
	)
fi

mv "$work/src" "$work/${pn}-${pv}"
tar -C "$work" --sort=name --owner=0 --group=0 --numeric-owner --mtime='@0' \
	-I 'zstd -19 -T0 --long=31' -cf "$out/${pn}-${pv}.full.tar.zst" "${pn}-${pv}"
ls -l "$out/${pn}-${pv}.full.tar.zst"
