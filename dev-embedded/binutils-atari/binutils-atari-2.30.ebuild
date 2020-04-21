EAPI=7

DESCRIPTION="Binutils with support for the m68k-atari-mint target"
HOMEPAGE="https://freemint.github.io/"
SRC_URI="https://github.com/freemint/m68k-atari-mint-binutils-gdb/archive/binutils-2_30-mint-thotto.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc64"
IUSE=""
CTARGET=m68k-atari-mint

S="${WORKDIR}/m68k-atari-mint-binutils-gdb-binutils-2_30-mint-thotto"

MY_BUILDDIR=${WORKDIR}/build

src_unpack() {
	default
	mkdir -p "${MY_BUILDDIR}"
}

src_configure() {
	LIBPATH=/usr/$(get_libdir)/binutils/${CTARGET}/${PV}
	INCPATH=${LIBPATH}/include
	DATAPATH=/usr/share/binutils-data/${CTARGET}/${PV}
	TOOLPATH=/usr/${CHOST}/${CTARGET}
	BINPATH=${TOOLPATH}/binutils-bin/${PV}

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
		--enable-obsolete
		--enable-shared
		--enable-threads
		# Newer versions (>=2.27) offer a configure flag now.
		--enable-relro
		# Newer versions (>=2.24) make this an explicit option. #497268
		--enable-install-libiberty
		--disable-werror
		--with-bugurl="https://github.com/freemint/m68k-atari-mint-binutils-gdb/issues"
		--with-pkgversion="$(toolchain-binutils_pkgversion)"
		${EXTRA_ECONF}
		# Disable modules that are in a combined binutils/gdb tree. #490566
		--disable-{gdb,libdecnumber,readline,sim}
		# Strip out broken static link flags.
		# https://gcc.gnu.org/PR56750
		--without-stage1-ldflags
		# Change SONAME to avoid conflict across
		# {native,cross}/binutils, binutils-libs. #666100
		--with-extra-soversion-suffix=gentoo-${CATEGORY}-${PN}
	)
	echo ./configure "${myconf[@]}"
	"${S}"/configure "${myconf[@]}" || die

	sed -i \
		-e '/^MAKEINFO/s:=.*:= true:' \
		Makefile || die
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

	# Newer versions of binutils get fancy with ${LIBPATH} #171905
	cd "${ED}"/${LIBPATH}
	for d in ../* ; do
		[[ ${d} == ../${PV} ]] && continue
		mv ${d}/* . || die
		rmdir ${d} || die
	done

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
	local libiberty_headers=(
		# Not all the libiberty headers.  See libiberty/Makefile.in:install_to_libdir.
		demangle.h
		dyn-string.h
		fibheap.h
		hashtab.h
		libiberty.h
		objalloc.h
		splay-tree.h
	)
	doins "${libiberty_headers[@]/#/${S}/include/}"
	if [[ -d ${ED}/${LIBPATH}/lib ]] ; then
		mv "${ED}"/${LIBPATH}/lib/* "${ED}"/${LIBPATH}/
		rm -r "${ED}"/${LIBPATH}/lib
	fi

	# Generate an env.d entry for this binutils
	insinto /etc/env.d/binutils
	cat <<-EOF > "${T}"/env.d
		TARGET="${CTARGET}"
		VER="${PV}"
		LIBPATH="${EPREFIX}${LIBPATH}"
	EOF
	newins "${T}"/env.d ${CTARGET}-${PV}

	# Remove shared info pages
	rm -f "${ED}"/${DATAPATH}/info/{dir,configure.info,standards.info}

	# Trim all empty dirs
	find "${ED}" -depth -type d -exec rmdir {} + 2>/dev/null
}

pkg_postinst() {
	# Make sure this ${CTARGET} has a binutils version selected
	[[ -e ${EROOT}/etc/env.d/binutils/config-${CTARGET} ]] && return 0
	binutils-config ${CTARGET}-${PV}
}
