# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic

DESCRIPTION="File manager for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-files"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	=cosmic-base/cosmic-icons-${PV}
	x11-misc/xdg-utils
	>=gnome-base/gvfs-1.48.0
	media-video/ffmpeg
	media-video/ffmpegthumbnailer
"

PATCHES=(
	"${FILESDIR}"/cosmic-files-inline-rename-video-info.patch
)
