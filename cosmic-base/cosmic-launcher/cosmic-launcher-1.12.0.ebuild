# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="Launcher for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-launcher"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	=cosmic-base/pop-launcher-${PV}
"
DEPEND="${RDEPEND}"
