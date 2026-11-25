# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="Workspaces overview for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-workspaces-epoch"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	>=media-libs/mesa-24.0.4
"
DEPEND+="
	>=media-libs/mesa-24.0.4
"
