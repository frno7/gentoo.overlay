EAPI=7

inherit font font-ebdftopcf

DESCRIPTION="Spleen is a monospaced bitmap font"
HOMEPAGE="https://github.com/fcambus/spleen"

LICENSE="public-domain" # Bitmap fonts are not copyrightable
SLOT="0"
IUSE="+otb otf"

if [[ ${PV} = *9999* ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fcambus/${PN}.git"
	BDEPEND+=" otf? ( media-gfx/fontforge media-fonts/bdf2sfd )"
else
	SRC_URI="https://github.com/fcambus/${PN}/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 m68k mips ppc ppc64 riscv s390 x86"
	S=${WORKDIR}/${P}
fi

BDEPEND+=" otb? ( x11-apps/fonttosfnt )"

RESTRICT="strip binchecks" # Only install fonts

src_compile() {
	if [[ ${PV} = *9999* ]]
	then
		use otf && emake -f "${FILESDIR}/Makefile" otf
	else
		use otb && rm *.otb
	fi

	use otb && emake -f "${FILESDIR}/Makefile" otb
	use X   && font-ebdftopcf_src_compile
}

src_install() {
	use otb && FONT_SUFFIX=otb    font_src_install
	use otf && FONT_SUFFIX=otf    font_src_install
	use X   && FONT_SUFFIX=pcf.gz font_src_install
}
