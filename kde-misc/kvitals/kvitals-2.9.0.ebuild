# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Lightweight KDE Plasma 6 panel widget that displays live system vitals"
HOMEPAGE="https://github.com/yassine20011/kvitals"
SRC_URI="https://github.com/yassine20011/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-qt/qtdeclarative:6
	kde-frameworks/kcmutils:6
	kde-frameworks/kirigami:6
	kde-frameworks/kitemmodels:6
	kde-frameworks/kpackage:6
	kde-plasma/ksystemstats:6
	kde-plasma/libksysguard:6
	kde-plasma/plasma-workspace:6
"

src_install() {
	insinto /usr/share/plasma/plasmoids/org.kde.plasma.kvitals
	doins metadata.json
	doins -r contents

	einstalldocs
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "KVitals has been installed system-wide."
	elog "If it does not appear in Plasma's widget picker immediately, restart plasmashell."
}
