# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GNU APL is a free interpreter for the programming language APL"
HOMEPAGE="https://www.gnu.org/software/apl/"
SRC_URI="https://ftp.gnu.org/gnu/apl/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-fix-long-double-overflow.patch"
)

