# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit cmake distutils-r1 xdg

DESCRIPTION="Automatic Material You color scheme generator for KDE Plasma"
HOMEPAGE="https://github.com/luisbocanegra/kde-material-you-colors"
SRC_URI="https://github.com/luisbocanegra/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+plasmoid pywal"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/materialyoucolor[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/python-magic[${PYTHON_USEDEP}]
	')
	kde-plasma/plasma-workspace
	plasmoid? (
		kde-plasma/libplasma
		kde-plasma/plasma5support
	)
	pywal? (
		x11-misc/pywal16
	)
"

DEPEND="
	${RDEPEND}
	dev-qt/qtbase=[dbus,gui]
"

BDEPEND="
	kde-frameworks/extra-cmake-modules
"

src_prepare() {
	cmake_src_prepare
	distutils-r1_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_PLASMOID=$(usex plasmoid)
		-DPACKAGE_PLASMOID=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	distutils-r1_src_compile
}

src_install() {
	cmake_src_install
	distutils-r1_src_install
}
