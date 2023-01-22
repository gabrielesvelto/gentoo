# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Abstraction library between applications and audio visualisation plugins"
HOMEPAGE="http://libvisual.org/"
SRC_URI="https://github.com/Libvisual/libvisual/releases/download/${P}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0.4"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc ~x86"
IUSE="debug nls threads"

BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.0-better-altivec-detection.patch
)

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/libvisual-0.4/libvisual/lvconfig.h
)

src_prepare() {
	default

	# autogenerated, causes problems for out of tree builds
	rm libvisual/lvconfig.h || die
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		--disable-examples \
		$(use_enable nls) \
		$(use_enable threads) \
		$(use_enable debug)
}

multilib_src_install_all() {
	einstalldocs

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
