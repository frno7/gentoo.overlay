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
	SRC_URI="https://github.com/frno7/toslibc/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/toslibc-${PV}"
	KEYWORDS="amd64 arm64 ppc64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="
	cross-m68k-elf/binutils
"
BDEPEND=""

pkg_setup() {
	MAKEOPTS+=" prefix=/usr/m68k-atari-tos-gnu "
	MAKEOPTS+=" TARGET_COMPILE=m68k-elf- "
	MAKEOPTS+=" DESTDIR=${D} V=1 "
}

src_compile() {
	emake binutils
}

src_install() {
	emake install-binutils

	for f in "${D}"/usr/m68k-atari-tos-gnu/bin/*
	do
		b="$(basename $f)"
		dosym /usr/m68k-atari-tos-gnu/bin/"$b" /usr/bin/"$b"
	done
}
