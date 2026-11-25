# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

EAPI=8

COSMIC_KIND="rust"
inherit depos-cosmic pam systemd

DESCRIPTION="Login greeter for the COSMIC desktop"
HOMEPAGE="https://github.com/pop-os/cosmic-greeter"
SRC_URI="https://github.com/ycderman/cosmic-overlay/releases/download/epoch-${PV}/${P}.full.tar.zst"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND+="
	=cosmic-base/cosmic-comp-${PV}
	acct-user/cosmic-greeter
	>=gui-libs/greetd-0.9.0
	>=media-libs/dav1d-1.4.2
	>=sys-libs/pam-1.5.3-r1
"
DEPEND+="
	>=sys-libs/pam-1.5.3-r1
	>=media-libs/dav1d-1.4.2
"

PATCHES=(
	"${FILESDIR}"/cosmic-greeter-no-lock-on-sleep.patch
)

src_install() {
	depos-cosmic_src_install
	systemd_dounit debian/cosmic-greeter.service debian/cosmic-greeter-daemon.service
	insinto /etc/greetd
	doins cosmic-greeter.toml
	newpamd "${FILESDIR}"/cosmic-greeter.pam cosmic-greeter
	insinto /etc/security
	doins "${FILESDIR}"/cosmic-greeter-env.conf
}
