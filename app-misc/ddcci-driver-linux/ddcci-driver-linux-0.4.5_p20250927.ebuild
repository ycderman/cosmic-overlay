# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

COMMIT="bbb7553373f815d78e93a4a9f071ce968563694a"

DESCRIPTION="DDC/CI kernel drivers; exposes external monitors as backlight devices"
HOMEPAGE="https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux"
SRC_URI="https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux/-/archive/${COMMIT}/ddcci-driver-linux-${COMMIT}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/ddcci-driver-linux-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

CONFIG_CHECK="I2C ~BACKLIGHT_CLASS_DEVICE"

src_compile() {
	local modlist=(
		ddcci=extra:ddcci:ddcci:module
		ddcci-backlight=extra:ddcci-backlight:ddcci-backlight:module
	)
	local modargs=( KDIR="${KV_OUT_DIR}" KVER="${KV_FULL}" )
	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install
	insinto /usr/lib/modules-load.d
	newins - ddcci.conf <<-EOT
		ddcci
		ddcci-backlight
	EOT
}
