# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

DESCRIPTION="COSMIC desktop as used by DepOS (no store, no Flatpak)"
HOMEPAGE="https://github.com/pop-os/cosmic-epoch"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	=cosmic-base/cosmic-comp-${PV}
	=cosmic-base/cosmic-session-${PV}
	=cosmic-base/cosmic-panel-${PV}
	=cosmic-base/cosmic-applets-${PV}
	=cosmic-base/cosmic-app-library-${PV}
	=cosmic-base/cosmic-bg-${PV}
	=cosmic-base/cosmic-launcher-${PV}
	=cosmic-base/pop-launcher-${PV}
	=cosmic-base/cosmic-notifications-${PV}
	=cosmic-base/cosmic-osd-${PV}
	=cosmic-base/cosmic-settings-${PV}
	=cosmic-base/cosmic-settings-daemon-${PV}
	=cosmic-base/cosmic-workspaces-epoch-${PV}
	=cosmic-base/cosmic-greeter-${PV}
	=cosmic-base/cosmic-idle-${PV}
	=cosmic-base/cosmic-files-${PV}
	=cosmic-base/cosmic-term-${PV}
	=cosmic-base/cosmic-edit-${PV}
	=cosmic-base/cosmic-screenshot-${PV}
	=cosmic-base/cosmic-randr-${PV}
	=cosmic-base/xdg-desktop-portal-cosmic-${PV}
	=cosmic-base/cosmic-icons-${PV}
	=cosmic-base/cosmic-sound-theme-${PV}
	cosmic-base/cosmic-ext-applet-minimon
"
