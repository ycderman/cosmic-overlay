# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="COSMIC panel applet for external monitor brightness (DDC/CI)"
HOMEPAGE="https://github.com/cosmic-utils/cosmic-ext-applet-external-monitor-brightness"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/cosmic-ext-applet-external-monitor-brightness-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	app-misc/ddcutil
"

PATCHES=(
	"${FILESDIR}"/external-monitor-brightness-no-git.patch
)
