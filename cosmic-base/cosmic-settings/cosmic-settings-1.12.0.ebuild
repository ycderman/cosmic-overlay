# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="Settings application for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-settings"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	=cosmic-base/cosmic-icons-${PV}
	=cosmic-base/cosmic-randr-${PV}
	>=net-wireless/bluez-5.86
	>=app-text/iso-codes-4.16.0
	>=dev-libs/expat-2.5.0
	>=dev-util/desktop-file-utils-0.27
	media-fonts/fira-mono
	media-fonts/fira-sans
	x11-misc/xkeyboard-config
	sys-apps/accountsservice
"
DEPEND+="
	>=dev-libs/expat-2.5.0
"
