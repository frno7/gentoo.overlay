EAPI=8

inherit toolchain-funcs

DESCRIPTION="Decompression routines for ancient formats"
HOMEPAGE="https://github.com/temisu/ancient/"

if [[ ${PV} = *9999* ]]
then
	EGIT_REPO_URI="https://github.com/temisu/ancient.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/temisu/ancient/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 arm64 ppc64"
fi

LICENSE="BSD-2 BZIP2"
SLOT="0"

src_configure() {
	autoreconf -i

	econf
}
