EAPI=7

inherit font font-ebdftopcf

DESCRIPTION="The system fonts of the Atari ST personal computer family"
HOMEPAGE="https://github.com/frno7/fonts"

LICENSE="public-domain" # Bitmap fonts are not copyrightable
SLOT="0"
IUSE="+otb otf"

if [[ ${PV} = *9999* ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/frno7/fonts.git"
	BDEPEND="otf? ( media-gfx/fontforge media-fonts/bdf2sfd x11-apps/fonttosfnt )"
else
	SRC_URI="https://github.com/frno7/fonts/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 m68k mips ppc ppc64 riscv s390 x86"
	S=${WORKDIR}/${P}
fi

FONT_S="${S}/atari"

RESTRICT="strip binchecks" # Only install fonts

src_compile() {
	use otb && emake atari_otb
	use otf && emake atari_otf
	use X   && font-ebdftopcf_src_compile
}

src_install() {
	use otb && FONT_SUFFIX=otb    font_src_install
	use otf && FONT_SUFFIX=otf    font_src_install
	use X   && FONT_SUFFIX=pcf.gz font_src_install
}
