EAPI=7

inherit font

DESCRIPTION="Lucir is a variant of Lucida Typewriter in 6x11 pixel size"
HOMEPAGE="https://github.com/frno7/font"

if [[ ${PV} = *9999* ]]
then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/frno7/font.git"
else
	SRC_URI="https://github.com/frno7/font/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm arm64 m68k mips ppc ppc64 riscv s390 x86"
	S=${WORKDIR}/${P}
fi

FONT_S="${S}/lucir"
FONT_SUFFIX="otf"

LICENSE="public-domain" # bitmap font, not copyrightable
SLOT="0"
