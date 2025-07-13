# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit verify-sig

DESCRIPTION="Talos II firmware system package"
HOMEPAGE="https://wiki.raptorcs.com/wiki/Talos_II/Firmware"
SRC_URI="
	https://wiki.raptorcs.com/w/images/9/91/Talos-ii-openbmc-v2.00-bundle.tar
		-> talos-ii-openbmc-v2.00-bundle.tar
	https://wiki.raptorcs.com/w/images/e/ec/Talos-ii-pnor-v2.00-bundle.tar
		-> talos-ii-pnor-v2.00-bundle.tar
	https://wiki.raptorcs.com/w/images/7/75/Talos-ii-system-fpga-v1.08.rom
		-> talos-ii-system-fpga-v1.08.rom
	verify-sig? (
		https://raptorcs.com/verification/gpg/talos_ii/firmware_builds/v2.00/talos-ii-openbmc-v2.00-bundle.tar.asc
		https://raptorcs.com/verification/gpg/talos_ii/firmware_builds/v2.00/talos-ii-pnor-v2.00-bundle.tar.asc
		https://raptorcs.com/verification/gpg/talos_ii/firmware_builds/v2.00/talos-ii-system-fpga-v1.08.rom.asc
	)
"

LICENSE="BSD GPL-2 MIT"
SLOT="${PV}"
KEYWORDS="amd64 arm64 ppc64 riscv"

DEPEND=""
RDEPEND="${DEPEND}"

BDEPEND="
    verify-sig? ( sec-keys/openpgp-keys-raptorcs )
"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/raptorcs.asc

S="${WORKDIR}"

src_unpack() {
	default

	unpack shell_upgrade/*.bz2
}

src_install() {
	local fw=/lib/firmware/talos-ii/"${PV}"

	insinto "${fw}"/bmc
	doins talos-ii-*-image-bmc

	insinto "${fw}"/pnor
	doins talos-ii-*.pnor

	insinto "${fw}"/fpga
	doins "${DISTDIR}"/*.rom

	insinto "${fw}"/web
	doins web_ipmi_upgrade/*
}

pkg_postinst() {
	elog "Review:"
	elog
	elog "https://wiki.raptorcs.com/wiki/Talos_II/Firmware#System_Package_v2.00"
	elog "https://wiki.raptorcs.com/wiki/Talos_II/Firmware/2.00/Release_Notes"
	elog "https://wiki.raptorcs.com/wiki/Updating_Firmware"
	elog
	elog "https://wiki.raptorcs.com/wiki/File:Talos-ii-openbmc-v2.00-bundle.tar"
	elog "https://wiki.raptorcs.com/wiki/File:Talos-ii-pnor-v2.00-bundle.tar"
	elog "https://wiki.raptorcs.com/wiki/File:Talos-ii-system-fpga-v1.08.rom"
	elog
}
