# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="Modular IPC-based desktop launcher service"
HOMEPAGE="https://github.com/pop-os/launcher"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	sci-libs/libqalculate
	>=sys-apps/fd-9
	sys-power/power-profiles-daemon
"
DEPEND="${RDEPEND}"
