# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="Session manager for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-session"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	=cosmic-base/cosmic-comp-${PV}
	=cosmic-base/cosmic-panel-${PV}
	=cosmic-base/cosmic-applets-${PV}
	=cosmic-base/cosmic-app-library-${PV}
	=cosmic-base/cosmic-bg-${PV}
	=cosmic-base/cosmic-launcher-${PV}
	=cosmic-base/cosmic-notifications-${PV}
	=cosmic-base/cosmic-osd-${PV}
	=cosmic-base/cosmic-settings-${PV}
	=cosmic-base/cosmic-settings-daemon-${PV}
	=cosmic-base/cosmic-workspaces-epoch-${PV}
	=cosmic-base/cosmic-idle-${PV}
	=cosmic-base/cosmic-icons-${PV}
	=cosmic-base/xdg-desktop-portal-cosmic-${PV}
	sys-apps/xdg-desktop-portal
"
