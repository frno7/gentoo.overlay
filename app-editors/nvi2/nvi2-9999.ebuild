EAPI=8

inherit cmake

DESCRIPTION="Reimplementation of the classic 4BSD ex/vi"
HOMEPAGE="https://github.com/lichray/nvi2"

if [[ ${PV} = *9999* ]]
then
	EGIT_REPO_URI="https://github.com/lichray/${PN}.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/lichray/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm hppa ~mips ppc ppc64 sparc x86 ~x64-macos"
fi

LICENSE="BSD"
SLOT="0"
IUSE="iconv +widechar"

CDEPEND="
	sys-libs/db:1
	sys-libs/ncurses
	iconv? ( virtual/libiconv )
"

DEPEND="${CDEPEND}
	virtual/pkgconfig
"

RDEPEND="${CDEPEND}
	app-eselect/eselect-vi
"

src_prepare() {
	cmake_src_prepare

	sed -i '/add_compile_options(-fcolor-diagnostics)/d' CMakeLists.txt
}

src_configure() {
	local mycmakeargs=(
		-DUSE_ICONV="$(usex iconv)"
		-DUSE_WIDECHAR="$(usex widechar)"
	)

	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/nvi
	newman man/vi.1 nvi.1
}

pkg_postinst() {
	eselect vi update --if-unset
}

pkg_postrm() {
	eselect vi update --if-unset
}
