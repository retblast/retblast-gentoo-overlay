# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Handy, infinite brainstorming tool"
HOMEPAGE="https://apps.kde.org/drawy/ https://invent.kde.org/graphics/drawy"
SRC_URI="https://invent.kde.org/graphics/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

QT_MIN="6.9.0"
KF_MIN="6.19.0"

BDEPEND="
	>=dev-build/cmake-3.27
	>=kde-frameworks/extra-cmake-modules-${KF_MIN}
	virtual/pkgconfig
	x11-misc/shared-mime-info
"

DEPEND="
	>=dev-qt/qtbase-${QT_MIN}:6[dbus,gui,widgets]
	>=kde-frameworks/kconfig-${KF_MIN}:6
	>=kde-frameworks/kconfigwidgets-${KF_MIN}:6
	>=kde-frameworks/kcoreaddons-${KF_MIN}:6
	>=kde-frameworks/kcrash-${KF_MIN}:6
	>=kde-frameworks/ki18n-${KF_MIN}:6
	>=kde-frameworks/kiconthemes-${KF_MIN}:6
	>=kde-frameworks/syntax-highlighting-${KF_MIN}:6
	>=kde-frameworks/kwidgetsaddons-${KF_MIN}:6
	>=kde-frameworks/kxmlgui-${KF_MIN}:6
	app-arch/zstd:=
	test? ( >=dev-qt/qtbase-${QT_MIN}:6[test] )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DUSE_DBUS=ON
		-DUSE_UNITY_CMAKE_SUPPORT=OFF
		-DENABLE_PCH=OFF
		-DKF6DocTools_DIR=
	)

	cmake_src_configure
}
