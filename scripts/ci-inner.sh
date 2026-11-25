#!/usr/bin/env bash
# Runs inside the Gentoo container: install build deps (binary packages where
# possible), then build the requested atom and keep the binary package + log.
set -euo pipefail
atom=$1
jobs=$(nproc)

eselect profile set default/linux/amd64/23.0/desktop/systemd

mkdir -p /etc/portage/repos.conf /etc/portage/package.accept_keywords /etc/portage/package.mask /etc/portage/package.use
cat > /etc/portage/repos.conf/depos-cosmic.conf <<CONF
[depos-cosmic]
location = /var/db/repos/depos-cosmic
CONF

cat >> /etc/portage/make.conf <<CONF
MAKEOPTS="-j${jobs}"
FEATURES="\${FEATURES} getbinpkg binpkg-request-signature buildpkg -news"
EMERGE_DEFAULT_OPTS="--jobs=2 --load-average=${jobs} --binpkg-respect-use=y --with-bdeps=y --quiet-build=y --color=n"
ACCEPT_LICENSE="*"
PKGDIR="/out/binpkgs"
PORTAGE_LOGDIR="/out/logs"
CONF

cat > /etc/portage/package.accept_keywords/depos <<CONF
cosmic-base/*::depos-cosmic ~amd64
acct-user/cosmic-greeter::depos-cosmic ~amd64
acct-group/cosmic-greeter::depos-cosmic ~amd64
x11-themes/pop-icon-theme::depos-cosmic ~amd64
x11-themes/adw-gtk3::depos-cosmic ~amd64
CONF
# Use the prebuilt Rust toolchain.
echo "dev-lang/rust" > /etc/portage/package.mask/rust

getuto
mkdir -p /out/logs

echo "::group::build dependencies"
emerge --onlydeps --onlydeps-with-rdeps=n "$atom"
echo "::endgroup::"

echo "::group::build $atom"
emerge --nodeps --buildpkg "$atom"
echo "::endgroup::"

