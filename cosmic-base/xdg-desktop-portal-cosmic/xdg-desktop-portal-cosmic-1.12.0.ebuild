# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="XDG desktop portal backend for COSMIC"
HOMEPAGE="https://github.com/pop-os/xdg-desktop-portal-cosmic"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	sys-apps/xdg-desktop-portal
	>=media-video/pipewire-1.0.5
	>=media-libs/mesa-24.0.4
"
