#!/usr/bin/env python3
"""Generate cosmic-base ebuilds and Manifest entries for one COSMIC epoch.

Usage: gen.py <pv> <dist-dir>

<dist-dir> holds the "<pn>-<pv>.full.tar.zst" files made by vendor.sh.
Older versions are kept, at most KEEP versions per package.
"""
import hashlib
import json
import os
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REPO_URL = "https://github.com/ycderman/cosmic-overlay"
KEEP = 2

EBUILD = """\
# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="{kind}"
inherit depos-cosmic{inherit}

DESCRIPTION="{desc}"
HOMEPAGE="https://github.com/pop-os/{repo}"
SRC_URI="{repo_url}/releases/download/epoch-${{PV}}/${{P}}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
{deps}{install}"""

META = """\
# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

DESCRIPTION="COSMIC desktop as used by DepOS (no store, no Flatpak)"
HOMEPAGE="https://github.com/pop-os/cosmic-epoch"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
{deps}
"
"""


def digest(path: Path) -> str:
    b2 = hashlib.blake2b()
    sha = hashlib.sha512()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            b2.update(chunk)
            sha.update(chunk)
    return f"DIST {path.name} {path.stat().st_size} BLAKE2B {b2.hexdigest()} SHA512 {sha.hexdigest()}"


def version_key(v: str):
    return [int(x) for x in re.findall(r"\d+", v)]


def prune(pkgdir: Path, pn: str) -> None:
    ebuilds = sorted(pkgdir.glob(f"{pn}-*.ebuild"), key=lambda p: version_key(p.stem[len(pn) + 1:]))
    for old in ebuilds[:-KEEP]:
        old.unlink()
    keep = {p.stem for p in pkgdir.glob(f"{pn}-*.ebuild")}
    manifest = pkgdir / "Manifest"
    if manifest.exists():
        lines = [l for l in manifest.read_text().splitlines()
                 if l.split()[1].removesuffix(".full.tar.zst") in keep]
        manifest.write_text("".join(l + "\n" for l in sorted(lines)))


def main() -> None:
    pv, dist = sys.argv[1], Path(sys.argv[2])
    pkgs = json.loads((ROOT / "packages.json").read_text())["packages"]

    for p in pkgs:
        pn = p["pn"]
        tarball = dist / f"{pn}-{pv}.full.tar.zst"
        if not tarball.exists():
            sys.exit(f"missing {tarball}")
        pkgdir = ROOT / "cosmic-base" / pn
        pkgdir.mkdir(parents=True, exist_ok=True)

        deps = ""
        if p["rdepend"]:
            lines = "\n".join(f"\t{d}" for d in p["rdepend"])
            op = "+=" if p["kind"] == "rust" else "="
            deps = f'\nRDEPEND{op}"\n{lines}\n"\n'
            if p["kind"] == "rust":
                deps += 'DEPEND="${RDEPEND}"\n'
        inherit = "".join(" " + i for i in p.get("inherit", []))
        install = ""
        if p.get("install"):
            body = "\n".join("\t" + l for l in p["install"])
            install = f"\nsrc_install() {{\n\tdepos-cosmic_src_install\n{body}\n}}\n"
        (pkgdir / f"{pn}-{pv}.ebuild").write_text(EBUILD.format(
            kind=p["kind"], desc=p["desc"], repo=p["repo"], repo_url=REPO_URL,
            inherit=inherit, deps=deps, install=install))

        manifest = pkgdir / "Manifest"
        entries = manifest.read_text().splitlines() if manifest.exists() else []
        entries = [e for e in entries if e.split()[1] != tarball.name] + [digest(tarball)]
        manifest.write_text("".join(e + "\n" for e in sorted(entries)))

        if not (pkgdir / "metadata.xml").exists():
            (pkgdir / "metadata.xml").write_text(
                '<?xml version="1.0" encoding="UTF-8"?>\n'
                '<!DOCTYPE pkgmetadata SYSTEM "https://www.gentoo.org/dtd/metadata.dtd">\n'
                "<pkgmetadata>\n"
                f'\t<upstream>\n\t\t<remote-id type="github">pop-os/{p["repo"]}</remote-id>\n\t</upstream>\n'
                "</pkgmetadata>\n")
        prune(pkgdir, pn)

    metadir = ROOT / "cosmic-base" / "cosmic-meta"
    metadir.mkdir(parents=True, exist_ok=True)
    deps = "\n".join(f"\t=cosmic-base/{p['pn']}-${{PV}}" for p in pkgs)
    (metadir / f"cosmic-meta-{pv}.ebuild").write_text(META.format(deps=deps))
    prune(metadir, "cosmic-meta")

    (ROOT / "EPOCH").write_text(pv + "\n")


if __name__ == "__main__":
    main()
