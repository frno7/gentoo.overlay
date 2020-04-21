EAPI=7

GCC_VERS=${PV/_p*/}
DESCRIPTION="The GNU Compiler Collection with support for the m68k-atari-mint target"
HOMEPAGE="https://freemint.github.io/"
SRC_URI="https://github.com/freemint/m68k-atari-mint-gcc/archive/gcc-7_5_0-mint-20191230.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc64"
IUSE=""
CTARGET=m68k-atari-mint

BDEPEND="dev-embedded/binutils-atari"

S="${WORKDIR}/m68k-atari-mint-gcc-gcc-7_5_0-mint-20191230"

MY_BUILDDIR=${WORKDIR}/build

src_unpack() {
	default
	mkdir -p "${MY_BUILDDIR}"
}

src_configure() {
	LIBPATH=/usr/$(get_libdir)/gcc/${CTARGET}/${PV}
	INCPATH=${LIBPATH}/include
	DATAPATH=/usr/share/gcc-data/${CTARGET}/${PV}
	TOOLPATH=/usr/${CHOST}/${CTARGET}
	BINPATH=${TOOLPATH}/gcc-bin/${PV}

	# Keep things sane
	strip-flags

	cd "${MY_BUILDDIR}"
	local myconf=()

	myconf+=(
		--prefix="${EPREFIX}"/usr
		--host=${CHOST}
		--target=${CTARGET}
		--datadir="${EPREFIX}"${DATAPATH}
		--datarootdir="${EPREFIX}"${DATAPATH}
		--infodir="${EPREFIX}"${DATAPATH}/info
		--mandir="${EPREFIX}"${DATAPATH}/man
		--bindir="${EPREFIX}"${BINPATH}
		--libdir="${EPREFIX}"${LIBPATH}
		--libexecdir="${EPREFIX}"${LIBPATH}
		--includedir="${EPREFIX}"${INCPATH}
		--enable-languages=c
		--disable-threads
		--disable-libmudflap
		--disable-libgomp
		--disable-nsl
		--disable-shared
		--disable-libssp
		--without-headers
		--with-gnu-as
		--with-gnu-ld
		--with-bugurl="https://github.com/freemint/m68k-atari-mint-gcc/issues"
		--with-pkgversion="$(toolchain-gcc_pkgversion)"
		${EXTRA_ECONF}
		# Change SONAME to avoid conflict across
		# {native,cross}/gcc, gcc-libs. #666100
		--with-extra-soversion-suffix=gentoo-${CATEGORY}-${PN}
	)
	echo ./configure "${myconf[@]}"
	"${S}"/configure "${myconf[@]}" || die
}

src_compile() {
	cd "${MY_BUILDDIR}"
	# see Note [tooldir hack for ldscripts]
	emake tooldir="${EPREFIX}${TOOLPATH}" all

	# we nuke the manpages when we're left with junk
	# (like when we bootstrap, no perl -> no manpages)
	find . -name '*.1' -a -size 0 -delete
}

src_install() {
	local x d

	cd "${MY_BUILDDIR}"
	# see Note [tooldir hack for ldscripts]
	emake DESTDIR="${D}" tooldir="${EPREFIX}${LIBPATH}" install
	rm -rf "${ED}"/${LIBPATH}/bin

	# Now we collect everything intp the proper SLOT-ed dirs
	# When something is built to cross-compile, it installs into
	# /usr/$CHOST/ by default ... we have to 'fix' that :)
	cd "${ED}"/${BINPATH}
	for x in * ; do
		mv ${x} ${x/${CTARGET}-}
	done

	if [[ -d ${ED}/usr/${CHOST}/${CTARGET} ]] ; then
		mv "${ED}"/usr/${CHOST}/${CTARGET}/include "${ED}"/${INCPATH}
		mv "${ED}"/usr/${CHOST}/${CTARGET}/lib/* "${ED}"/${LIBPATH}/
		rm -r "${ED}"/usr/${CHOST}/{include,lib}
	fi
	insinto ${INCPATH}
	if [[ -d ${ED}/${LIBPATH}/lib ]] ; then
		mv "${ED}"/${LIBPATH}/lib/* "${ED}"/${LIBPATH}/
		rm -r "${ED}"/${LIBPATH}/lib
	fi

	# create gcc-config entry
	dodir /etc/env.d/gcc
	local gcc_envd_base="/etc/env.d/gcc/${CTARGET}-${PV}"

	gcc_envd_file="${ED}${gcc_envd_base}"

	echo "GCC_PATH=\"${BINPATH}\"" >> ${gcc_envd_file}
	echo "LDPATH=\"${LIBPATH}\"" >> ${gcc_envd_file}
	echo "MANPATH=\"${EPREFIX}/usr/share/gcc-data/${CTARGET}/${GCC_VERS}/man\"" >> ${gcc_envd_file}
	echo "INFOPATH=\"${EPREFIX}/usr/share/gcc-data/${CTARGET}/${GCC_VERS}/info\"" >> ${gcc_envd_file}
	echo "STDCXX_INCDIR=\"g++-v${GCC_VERS/\.*/}\"" >> ${gcc_envd_file}
	echo "CTARGET=${CTARGET}" >> ${gcc_envd_file}

	# Move <cxxabi.h> to compiler-specific directories
	[[ -f ${D}${STDCXX_INCDIR}/cxxabi.h ]] && \
		mv -f "${D}"${STDCXX_INCDIR}/cxxabi.h "${D}"${LIBPATH}/include/

	# These should be symlinks
	dodir /usr/bin
	cd "${D}"${BINPATH}
	for x in cpp gcc g++ c++ ; do
		[[ -f ${x} ]] && mv ${x} ${CTARGET}-${x}

		if [[ -f ${CTARGET}-${x}-${GCC_VERS} ]] ; then
			rm -f ${CTARGET}-${x}-${GCC_VERS}
			ln -sf ${CTARGET}-${x} ${CTARGET}-${x}-${GCC_VERS}
		fi
	done

	# Remove shared info pages
	rm -f "${ED}"/${DATAPATH}/info/{dir,configure.info,standards.info}

	# Trim all empty dirs
	find "${ED}" -depth -type d -exec rmdir {} + 2>/dev/null
}

pkg_postinst() {
	gcc-config ${CTARGET}-${GCC_VERS}
}
