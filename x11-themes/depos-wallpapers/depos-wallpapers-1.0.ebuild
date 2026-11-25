# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

DESCRIPTION="DepOS wallpapers: modern, nature and landscape (3840x2160)"
HOMEPAGE="https://github.com/ycderman/cosmic-overlay"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/${P}/${P}.tar.xz"

LICENSE="CC0-1.0 CC-BY-2.0 CC-BY-4.0 CC-BY-SA-3.0 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	insinto /usr/share/backgrounds/depos
	doins *.jpg
	dodoc CREDITS
}
