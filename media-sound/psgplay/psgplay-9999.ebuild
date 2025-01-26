EAPI=8

inherit toolchain-funcs

DESCRIPTION="PSG play is a music player for Atari ST YM2149 SNDH files"
HOMEPAGE="https://github.com/frno7/psgplay"

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

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa doc"

RDEPEND="
	alsa? ( media-libs/alsa-lib )"
DEPEND=""
BDEPEND=""

pkg_setup() {
	MAKEOPTS+=" prefix=/usr libdir=/usr/$(get_libdir) V=1 "
	MAKEOPTS+=" BUILD_CC='$(tc-getBUILD_CC)' "
	MAKEOPTS+=" HOST_AR='$(tc-getAR)' HOST_CC='$(tc-getCC)' "

	use alsa && MAKEOPTS+=" ALSA=1 "
}

src_prepare() {
	default

	[[ ${PV} != *9999* ]] && echo ${PV} >version
}

src_install() {
	emake DESTDIR="${D}" install || die

	use doc && dodoc README.md
}
