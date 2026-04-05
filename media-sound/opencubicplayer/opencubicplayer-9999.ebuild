EAPI=8

inherit flag-o-matic

DESCRIPTION="Open Cubic Player for track and chip music"
HOMEPAGE="http://stian.cubic.org/"

if [[ ${PV} = *9999* ]]
then
	EGIT_REPO_URI="https://github.com/mywave82/opencubicplayer.git"
	inherit git-r3
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/mywave82/opencubicplayer/releases/download/v${PV}/ocp-${PV}.tar.gz"
	KEYWORDS="amd64 arm64 ppc64"
	S="${WORKDIR}/ocp-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="X alsa flac gme mad ncurses sdl2 sdl3"

RDEPEND="
	media-libs/libogg
	media-libs/libvorbis
	virtual/libiconv
	X? (
		x11-libs/libXext
		x11-libs/libXxf86vm
		x11-libs/libX11
		x11-libs/libXpm
	)
	alsa? ( media-libs/alsa-lib )
	flac? ( media-libs/flac )
	sdl2? ( media-libs/libsdl2 )
	sdl2? ( media-libs/libsdl3 )
	mad? ( media-libs/libmad )
	ncurses? ( sys-libs/ncurses )
"
DEPEND="
	$RDEPEND
	app-arch/ancient
	dev-embedded/xa
	dev-libs/cJSON
	media-libs/libdiscid
	sys-apps/texinfo
	X? (
		dev-util/desktop-file-utils
		media-fonts/unifont
	)
	sdl2? (
		dev-util/desktop-file-utils
		media-fonts/unifont
	)
	sdl3? (
		dev-util/desktop-file-utils
		media-fonts/unifont
	)
"

src_configure() {
	local myeconfargs=(
		--without-debug
		--without-oss
		--without-lzw
		--without-lzh
		--without-sdl
		--without-sdl2
		--without-sdl3
		--without-coreaudio
		--with-unifontdir-otf=/usr/share/fonts/unifont
		--with-unifont-csur-otf=/usr/share/fonts/unifont
		--with-unifont-upper-otf=/usr/share/fonts/unifont
		$(use_with X x11)
		$(use_with alsa)
		$(use_with flac)
		$(use_with gme libgme)
		$(use_with mad)
		$(use_with ncurses)
		$(use_with sdl2 sdl2)
		$(use_with sdl3 sdl3)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR=${D} install

	# QA Notice: One or more compressed files were found in docompress-ed
	# directories. Please fix the ebuild not to install compressed files
	# (manpages, documentation) when automatic compression is used:
	gzip -d ${D}/usr/share/info/ocp.info.gz
}
