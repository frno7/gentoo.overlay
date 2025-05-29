EAPI=8

inherit toolchain-funcs

DESCRIPTION="32-bit assembler and linker tools for Atari TOS"
HOMEPAGE="https://github.com/frno7/toslibc"

if [[ ${PV} = *9999* ]]
then
	EGIT_REPO_URI="https://github.com/frno7/toslibc.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	EGIT_REPO_URI="https://github.com/frno7/toslibc.git"
	EGIT_COMMIT="v${PV}"
	inherit git-r3
	SRC_URI=""
	KEYWORDS="amd64 ppc64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="cross-m68k-elf/binutils"
BDEPEND=""

pkg_setup() {
	MAKEOPTS+=" prefix=/usr/m68k-atari-tos-gnu V=1 "
	MAKEOPTS+=" TARGET_COMPILE=m68k-elf- "
	MAKEOPTS+=" DESTDIR=${D} "
}

src_compile() {
	emake binutils || die
}

src_install() {
	emake install-binutils || die

	for f in "${D}"/usr/m68k-atari-tos-gnu/bin/*
	do
		b="$(basename $f)"
		dosym /usr/m68k-atari-tos-gnu/bin/"$b" /usr/bin/"$b"
	done
}
