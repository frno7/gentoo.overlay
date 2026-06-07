EAPI=8

inherit toolchain-funcs

DESCRIPTION="32-bit C standard library for Atari TOS"
HOMEPAGE="https://github.com/frno7/toslibc"

if [[ ${PV} = *9999* ]]
then
	EGIT_REPO_URI="https://github.com/frno7/${PN}.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/frno7/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 ppc64"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="example test"

RDEPEND=""
DEPEND="
	cross-m68k-elf/gcc
"
BDEPEND=""
RESTRICT="strip"

pkg_setup() {
	MAKEOPTS+=" prefix=/usr/m68k-atari-tos-gnu "
	MAKEOPTS+=" TARGET_COMPILE=m68k-elf- "
	MAKEOPTS+=" DESTDIR=${D} V=1 "
}

src_compile() {
	emake lib

	use example && emake example
	use test    && emake test
}

src_install() {
	emake install-lib

	use example && emake install-example
	use test    && emake install-test
}
