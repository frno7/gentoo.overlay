# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Raptor Computing Systems"
HOMEPAGE="https://wiki.raptorcs.com/"
# The main key is 0x9B2BF5BD337BF51F (0x337BF51F) as
# Raptor Computing Systems Primary Signer (Umbrella Signer).
SRC_URI="
	https://raptorcs.com/keys/gpg/0x337BF51F.pub
		-> raptorcs-gpg-key-0x337BF51F.asc
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xA8808B68FBBEBF23
		-> raptorcs-gpg-key-0xA8808B68FBBEBF23.asc
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xED0AB3BA06F5A035
		-> raptorcs-gpg-key-0xED0AB3BA06F5A035.asc
	https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x101A7EF8EF283DDC
		-> raptorcs-gpg-key-0x101A7EF8EF283DDC.asc
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 riscv"

subkeys() {
	# Exclude main key 0x337BF51F
	echo "${A}" | sed 's/0x\|337BF51F//g' | tr -d '[\-/.a-z]'
}

src_compile() {
	local files=( ${A} )
	local -x GNUPGHOME=${T}/.gnupg

	mkdir "${GNUPGHOME}" || die
	gpg --import "${files[@]/#/${DISTDIR}/}" || die "Key import failed"
	# Checking signatures should display "gpg: 7 good signatures" by
	# 9B2BF5BD337BF51F Raptor Computing Systems Primary Signer
	# (Umbrella Signer) <authentication@raptorcs.com>.
	gpg --check-signatures $(subkeys)        || die "Key check failed"
}

src_install() {
	insinto /usr/share/openpgp-keys
	newins - raptorcs.asc < <(
		for x in ${A}; do
			cat "${DISTDIR}/${x}"
		done
	)
}
