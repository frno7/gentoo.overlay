EAPI=8

inherit toolchain-funcs

DESCRIPTION="Ice is a compression utility used on Atari ST machines"
HOMEPAGE="https://github.com/frno7/pack-ice"

if [[ ${PV} = *9999* ]]
then
	EGIT_REPO_URI="https://github.com/frno7/pack-ice.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/frno7/pack-ice/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ppc64"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND=""
DEPEND=""
BDEPEND=""

src_install() {
	mv icecat ice-cat
	mv freeze ice-freeze
	mv melt   ice-melt
	dobin ice-cat ice-freeze ice-melt
}
