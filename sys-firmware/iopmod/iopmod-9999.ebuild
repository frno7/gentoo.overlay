EAPI=7

inherit toolchain-funcs

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
IUSE="modules +tools static"

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

	if use tools
	then
		emake CC="$(tc-getCC)" AR="$(tc-getAR)" \
			LDFLAGS="${LDFLAGS}" V=1 tool || die
	fi

	if use modules
	then
		emake CC="$(tc-getBUILD_CC)" AR="$(tc-getBUILD_AR)" \
			CCC="$(tc-getCC)" CLD="$(tc-getLD)" \
			CFLAGS="-Wall -Iinclude" \
			LDFLAGS="${LDFLAGS}" V=1 module || die
	fi
}

src_install() {
	if use tools
	then
		dobin tool/iopmod-info
		dobin tool/iopmod-link
		dobin tool/iopmod-symc
	fi

	if use modules
	then
		insinto /lib/firmware/ps2
		doins module/*.irx
	fi
}
