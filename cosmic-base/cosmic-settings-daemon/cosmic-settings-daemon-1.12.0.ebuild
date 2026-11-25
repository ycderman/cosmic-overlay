# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="Settings daemon for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-settings-daemon"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	media-sound/alsa-utils
	>=media-sound/playerctl-2.3.1
	x11-themes/adw-gtk3
	x11-themes/pop-icon-theme
"
