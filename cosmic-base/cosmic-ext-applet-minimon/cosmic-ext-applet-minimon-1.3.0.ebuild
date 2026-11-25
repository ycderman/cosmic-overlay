# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="System monitor applet for the COSMIC panel"
HOMEPAGE="https://github.com/cosmic-utils/cosmic-ext-applet-minimon"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/cosmic-ext-applet-minimon-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
