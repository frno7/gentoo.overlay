EAPI=7

DESCRIPTION="PSG play is a music player for Atari ST YM2149 SNDH files"
HOMEPAGE="https://github.com/frno7/psgplay"

if [[ ${PV} = *9999* ]]
then
	EGIT_REPO_URI="https://github.com/frno7/${PN}.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/frno7/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ppc64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa doc"

RDEPEND="
	alsa? ( media-libs/alsa-lib )"
DEPEND="${DEPEND}"
BDEPEND=""

pkg_setup() {
    MAKEOPTS+=" prefix=/usr "

	use alsa && MAKEOPTS+=" ALSA=1 "
}

src_prepare() {
	default

	[[ ${PV} != *9999* ]] && echo ${PV} >version
}

src_compile() {
	emake SOFLAGS="-shared -Wl,-soname,libpsgplay.so.${PV%%.*}" || die

	mv lib/psgplay/libpsgplay.so lib/psgplay/libpsgplay.so.${PV}

	echo "prefix=/usr
libdir=/usr/$(get_libdir)
includedir=/usr/include

Name: psgplay
Description: PSG play is a music player for Atari ST YM2149 SNDH files
Version: ${PV}

Requires:"'
Libs: -L${libdir} -lpsgplay
Cflags: -I${includedir}' >libpsgplay.pc
}

src_install() {
	dobin psgplay

	use doc && dodoc README.md

	insinto /usr/$(get_libdir)/pkgconfig
	doins libpsgplay.pc

	into /usr
	dolib.so lib/psgplay/libpsgplay.so.${PV}
	dosym libpsgplay.so.${PV} /usr/$(get_libdir)/libpsgplay.so
	dosym libpsgplay.so.${PV} /usr/$(get_libdir)/libpsgplay.so.${PV%%.*}

	doman doc/psgplay.1

	insinto /usr/include/psgplay
	doins include/psgplay/*.h
}
