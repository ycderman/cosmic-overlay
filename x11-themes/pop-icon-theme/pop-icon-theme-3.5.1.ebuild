# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

inherit meson xdg

DESCRIPTION="Icon theme for Pop!_OS, base of the COSMIC icon theme"
HOMEPAGE="https://github.com/pop-os/icon-theme"
SRC_URI="https://github.com/pop-os/icon-theme/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/icon-theme-${PV}"

LICENSE="CC-BY-SA-4.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="x11-themes/adwaita-icon-theme"
