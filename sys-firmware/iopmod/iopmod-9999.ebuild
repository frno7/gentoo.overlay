EAPI=7

DESCRIPTION="PlayStation 2 input/output processor (IOP) modules and tools"
HOMEPAGE="https://github.com/frno7/iopmod"

if [[ ${PV} = *9999* ]]
then
	EGIT_REPO_URI="https://github.com/frno7/${PN}.git"
	EGIT_BRANCH=master
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/frno7/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ppc64"
fi

LICENSE="GPL-2 MIT"
SLOT="0"
IUSE="static"

RDEPEND=""
DEPEND=""
BDEPEND=""

src_prepare() {
	default

	echo ${PV} >version
}

src_compile() {
	local LDFLAGS="${LDFLAGS}"

	use static && LDFLAGS+=" -static"

	emake LDFLAGS="${LDFLAGS}" V=1 tool || die
}

src_install() {
	dobin tool/iopmod-info
	dobin tool/iopmod-link
	dobin tool/iopmod-symc
}
