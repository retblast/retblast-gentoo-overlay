# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="Independent web browser (official Ubuntu binary)"
HOMEPAGE="https://ladybird.org/"
MY_DEB="ladybird_${PV}-1~ubuntu24.04_amd64.deb"
SRC_URI="https://apt.ladybird.org/pool/main/l/ladybird/${MY_DEB}"

S="${WORKDIR}"
LICENSE="BSD-2
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BZIP2 Boost-1.0 curl FTL
	GPL-2+ IJG LGPL-2.1+ LGPL-3 MIT MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="strip"

RDEPEND="
	>=dev-libs/glib-2.80:2
	dev-libs/wayland
	media-fonts/liberation-fonts
	media-libs/libglvnd[X]
	media-libs/libpulse
	media-libs/vulkan-loader
	>=sys-devel/gcc-13.2
	>=sys-libs/glibc-2.39
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxkbcommon[X]
	x11-libs/xcb-util
	x11-libs/xcb-util-cursor
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
"
BDEPEND="app-arch/xz-utils"

src_unpack() {
	unpack_deb "${MY_DEB}"
}

src_install() {
	sed -i 's|^Exec=/opt/ladybird/bin/Ladybird|Exec=/usr/bin/ladybird|' \
		usr/share/applications/org.ladybird.Ladybird.desktop \
		usr/share/dbus-1/services/org.ladybird.Ladybird.service || die

	dodir /opt /usr/bin /usr/share
	cp -a --no-preserve=ownership opt/ladybird "${ED}/opt/" || die
	cp -a --no-preserve=ownership usr/share/. "${ED}/usr/share/" || die
	install -m 0755 "${FILESDIR}/ladybird" "${ED}/usr/bin/ladybird" || die
}
