EAPI=7

DESCRIPTION="Command-line program to download videos from some streaming sites"
HOMEPAGE="https://svtplay-dl.se/"

if [[ ${PV} = *9999* ]]
then
	EGIT_REPO_URI="https://github.com/spaam/${PN}.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/spaam/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ppc64"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${DEPEND}"
BDEPEND="
	app-arch/zip
	dev-lang/perl
	dev-python/cryptography
	dev-python/pysocks
	dev-python/pyyaml
	dev-python/requests"

src_compile() {
	emake svtplay-dl svtplay-dl.1 || die
}

src_install() {
	dobin svtplay-dl
	doman svtplay-dl.1
}
