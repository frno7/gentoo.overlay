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
	EGIT_REPO_URI="https://github.com/frno7/${PN}.git"
	EGIT_COMMIT="v${PV}"
	inherit git-r3
	SRC_URI=""
	KEYWORDS="amd64 ppc64"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="example test"

RDEPEND=""
DEPEND="cross-m68k-elf/gcc"
BDEPEND=""

pkg_setup() {
	MAKEOPTS+=" prefix=/usr/m68k-atari-tos-gnu V=1 "
	MAKEOPTS+=" TARGET_COMPILE=m68k-elf- "
	MAKEOPTS+=" DESTDIR=${D} "
}

src_compile() {
	emake lib || die

	use example && emake example
	use test    && emake test
}

src_install() {
	emake install-lib || die

	use example && emake install-example
	use test    && emake install-test
}
