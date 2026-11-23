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
	>=media-video/ffmpeg-6
	<media-video/ffmpeg-10
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
BDEPEND="
	app-arch/xz-utils
	dev-util/patchelf
"

src_unpack() {
	unpack_deb "${MY_DEB}"
}

src_prepare() {
	default

	# Keep the bundled ICU separate from the ICU used by system FFmpeg.
	local -a icu=( libicudata libicui18n libicuuc )
	local name elf needed
	local -a replacements
	for name in "${icu[@]}"; do
		patchelf --set-soname "${name}-ladybird.so.78" "opt/ladybird/lib/${name}.so.78" || die
		mv "opt/ladybird/lib/${name}.so.78" "opt/ladybird/lib/${name}-ladybird.so.78" || die
	done

	while IFS= read -r -d '' elf; do
		needed=$(patchelf --print-needed "${elf}") || die
		replacements=()
		for name in "${icu[@]}"; do
			if [[ $'\n'${needed}$'\n' == *$'\n'"${name}.so.78"$'\n'* ]]; then
				replacements+=( --replace-needed "${name}.so.78" "${name}-ladybird.so.78" )
			fi
		done
		if (( ${#replacements[@]} )); then
			patchelf "${replacements[@]}" "${elf}" || die
		fi
	done < <(find opt/ladybird/{bin,lib,libexec,Qt6/plugins} -type f -print0)
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
