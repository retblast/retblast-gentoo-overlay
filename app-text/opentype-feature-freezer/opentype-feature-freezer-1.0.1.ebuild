# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1

DESCRIPTION="Permanently apply OpenType features to fonts by remapping Unicode assignments"
HOMEPAGE="https://twardoch.github.io/fonttools-opentype-feature-freezer/"
SRC_URI="https://github.com/twardoch/fonttools-opentype-feature-freezer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# I don't care
RESTRICT="test"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="gui"

RDEPEND="
	>=dev-python/fonttools-4.60.0[${PYTHON_USEDEP}]
	gui? ( dev-python/ezgooey[${PYTHON_USEDEP}] )
"

BDEPEND="
	dev-python/hatchling[${PYTHON_USEDEP}]
"

S="${WORKDIR}/fonttools-opentype-feature-freezer-${PV}"

src_prepare() {
	# Same error I had on NixOS
	sed -i 's/import fontTools.ttLib as ttLib/import fontTools\nimport fontTools.ttLib as ttLib/' \
		src/opentype_feature_freezer/__init__.py || die
	distutils-r1_src_prepare
}