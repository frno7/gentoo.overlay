# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit verify-sig

DESCRIPTION="Talos II firmware system package"
HOMEPAGE="https://wiki.raptorcs.com/wiki/Talos_II/Firmware"
SRC_URI="
	https://wiki.raptorcs.com/w/images/7/79/Talos_ii_openbmc_v1.02_bundle.tar.bz2
		-> talos-ii-openbmc-v1.02-bundle.tar.bz2
	https://wiki.raptorcs.com/w/images/f/f4/Talos_ii_host_pnor_v1.02.bin.bz2
		-> talos-ii-pnor-v1.02.bin.bz2
	https://wiki.raptorcs.com/w/images/5/57/Talos-system-fpga-v1.04.rom
		-> talos-ii-system-fpga-v1.04.rom
	verify-sig? (
		https://raptorcs.com/verification/gpg/talos_ii/firmware_builds/v1.02/talos_ii_openbmc_v1.02_bundle.tar.bz2.asc
			-> talos-ii-openbmc-v1.02-bundle.tar.bz2.asc
		https://raptorcs.com/verification/gpg/talos_ii/firmware_builds/v1.02/talos_ii_host_pnor_v1.02.bin.bz2.asc
			-> talos-ii-pnor-v1.02.bin.bz2.asc
		https://raptorcs.com/verification/gpg/talos_ii/firmware_builds/v1.02/talos-system-fpga-v1.04.rom.asc
			-> talos-ii-system-fpga-v1.04.rom.asc
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

src_install() {
	local fw=/lib/firmware/talos-ii/"${PV}"

	insinto "${fw}"/bmc
	doins image-*

	insinto "${fw}"/pnor
	doins talos-ii-pnor-*.bin

	insinto "${fw}"/fpga
	doins "${DISTDIR}"/*.rom
}

pkg_postinst() {
	elog "Review:"
	elog
	elog "https://wiki.raptorcs.com/wiki/Talos_II/Firmware#System_Package_v1.02"
	elog "https://wiki.raptorcs.com/wiki/Updating_Firmware"
	elog
	elog "https://wiki.raptorcs.com/wiki/File:Talos_ii_openbmc_v1.02_bundle.tar.bz2"
	elog "https://wiki.raptorcs.com/wiki/File:Talos_ii_host_pnor_v1.02.bin.bz2"
	elog "https://wiki.raptorcs.com/wiki/File:Talos-system-fpga-v1.04.rom"
	elog
}
