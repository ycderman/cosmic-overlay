# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="meson"
inherit depos-cosmic

DESCRIPTION="Sound theme for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-sound-theme"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
