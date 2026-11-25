# Copyright 2026 ycderman
# Distributed under the terms of the GNU General Public License v3

# @ECLASS: depos-cosmic.eclass
# @MAINTAINER:
# ycderman
# @SUPPORTED_EAPIS: 8
# @BLURB: Build and install COSMIC desktop components from vendored release tarballs
# @DESCRIPTION:
# Every component is shipped as "${P}.full.tar.zst": the upstream "epoch-${PV}"
# tag with all Cargo dependencies vendored and a matching .cargo/config.toml.
# The tarballs are produced by scripts/vendor.sh and attached to the
# "epoch-${PV}" release of this repository.
#
# Building and installing go through the upstream justfile, so new files added
# upstream are installed without ebuild changes.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_DEPOS_COSMIC_ECLASS} ]]; then
_DEPOS_COSMIC_ECLASS=1

# @ECLASS_VARIABLE: COSMIC_KIND
# @PRE_INHERIT
# @DESCRIPTION:
# "rust" for Cargo projects built with just, "data" for justfile-only
# installs, "meson" for meson projects.
: "${COSMIC_KIND:=rust}"

if [[ ${COSMIC_KIND} == rust ]]; then
	RUST_MIN_VER="1.90.0"
	CARGO_OPTIONAL=1
	inherit cargo
	LLVM_COMPAT=( {19..22} )
	LLVM_OPTIONAL=1
	inherit llvm-r1
fi

[[ ${COSMIC_KIND} == meson ]] && inherit meson

inherit edo flag-o-matic multiprocessing toolchain-funcs xdg

BDEPEND="
	app-arch/zstd
	virtual/pkgconfig
"
[[ ${COSMIC_KIND} == meson ]] || BDEPEND+=" dev-build/just"

if [[ ${COSMIC_KIND} == rust ]]; then
	IUSE="max-opt"
	REQUIRED_USE="${LLVM_REQUIRED_USE}"
	BDEPEND+="
		${RUST_DEPEND}
		$(llvm_gen_dep 'llvm-core/clang:${LLVM_SLOT}')
	"
	RDEPEND="
		>=dev-libs/glib-2.78.3
		>=dev-libs/libinput-1.25.0
		>=dev-libs/wayland-1.22
		>=media-libs/libglvnd-1.7.0
		>=media-video/pipewire-1.0.5
		>=sys-auth/polkit-123-r1
		sys-apps/systemd:=
		>=virtual/libudev-251-r2
		>=x11-libs/libxkbcommon-1.6.0
		|| ( sys-apps/dbus-broker sys-apps/dbus )
	"
	DEPEND="${RDEPEND}"
fi

# @FUNCTION: depos-cosmic_pkg_setup
# @DESCRIPTION:
# Set up Rust and LLVM (libclang is needed by bindgen-based crates).
depos-cosmic_pkg_setup() {
	if [[ ${COSMIC_KIND} == rust ]]; then
		rust_pkg_setup
		llvm-r1_pkg_setup
	fi
}

# @FUNCTION: depos-cosmic_src_unpack
# @DESCRIPTION:
# Unpack the vendored release tarball into ${S}.
depos-cosmic_src_unpack() {
	mkdir -p "${S}" || die
	tar -x -I 'zstd -d --long=31' -C "${S}" --strip-components=1 \
		-f "${DISTDIR}/${P}.full.tar.zst" || die "unpack failed"
}

# @FUNCTION: depos-cosmic_src_configure
# @DESCRIPTION:
# Offline Cargo configuration and optimisation profile.
depos-cosmic_src_configure() {
	if [[ ${COSMIC_KIND} == meson ]]; then
		meson_src_configure
		return
	fi
	[[ ${COSMIC_KIND} == rust ]] || return 0

	export CARGO_HOME="${T}/cargo-home"
	mkdir -p "${CARGO_HOME}" || die
	export CARGO_NET_OFFLINE=true
	export CARGO_TERM_COLOR=never
	export CARGO_TERM_VERBOSE=true
	# vergen-based build scripts ask git for these; the tarball has no .git.
	export VERGEN_GIT_SHA="epoch-${PV}"
	export VERGEN_GIT_COMMIT_DATE="1970-01-01"
	export VERGEN_GIT_COMMIT_TIMESTAMP="1970-01-01T00:00:00Z"

	# Portage strips and splits debug info itself.
	export CARGO_PROFILE_RELEASE_DEBUG=0
	export CARGO_PROFILE_RELEASE_STRIP=false
	if use max-opt; then
		export CARGO_PROFILE_RELEASE_OPT_LEVEL=3
		export CARGO_PROFILE_RELEASE_CODEGEN_UNITS=1
		export CARGO_PROFILE_RELEASE_LTO=thin
	fi

	# C LTO flags leak into cc-rs builds and break Rust linking.
	filter-lto
	tc-export AR CC CXX PKG_CONFIG
	export RUSTFLAGS="${RUSTFLAGS}"
}

# @FUNCTION: depos-cosmic_src_compile
# @DESCRIPTION:
# Build through the upstream justfile when it has a build-release recipe.
depos-cosmic_src_compile() {
	if [[ ${COSMIC_KIND} == meson ]]; then
		meson_src_compile
		return
	fi
	[[ ${COSMIC_KIND} == rust ]] || return 0

	if just --summary 2>/dev/null | tr ' ' '\n' | grep -qx build-release; then
		edo just build-release --frozen -j "$(makeopts_jobs)"
	else
		edo cargo build --release --frozen -j "$(makeopts_jobs)"
	fi
}

# @FUNCTION: depos-cosmic_src_install
# @DESCRIPTION:
# Install with the upstream justfile into ${D}.
depos-cosmic_src_install() {
	if [[ ${COSMIC_KIND} == meson ]]; then
		meson_src_install
		return
	fi
	local vars=( rootdir="${D}" )
	# Not every justfile defines prefix (pop-launcher hardcodes /usr).
	just --evaluate prefix &>/dev/null && vars+=( prefix="${EPREFIX}/usr" )
	edo just "${vars[@]}" install
	einstalldocs
}

depos-cosmic_pkg_preinst() { xdg_pkg_preinst; }
depos-cosmic_pkg_postinst() { xdg_pkg_postinst; }
depos-cosmic_pkg_postrm() { xdg_pkg_postrm; }

fi

EXPORT_FUNCTIONS pkg_setup src_unpack src_configure src_compile src_install pkg_preinst pkg_postinst pkg_postrm
