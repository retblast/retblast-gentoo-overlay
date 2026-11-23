# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs unpacker xdg

DESCRIPTION="Independent web browser (official Ubuntu binary)"
HOMEPAGE="https://ladybird.org/"
MY_DEB="ladybird_${PV}-1~ubuntu24.04_amd64.deb"
FFMPEG_PV="9.0.2"
FFMPEG_DIR="/opt/ladybird/lib"
FFMPEG_PATCH_URI="https://raw.githubusercontent.com/LadybirdBrowser/ladybird/${PV}/Meta/CMake/vcpkg/overlay-ports/ffmpeg"
SRC_URI="
	https://apt.ladybird.org/pool/main/l/ladybird/${MY_DEB}
	vulkan-video? (
		https://ffmpeg.org/releases/ffmpeg-${FFMPEG_PV}.tar.xz
		${FFMPEG_PATCH_URI}/0100-ladybird-symbol-version-nodes.patch -> ${P}-ffmpeg-symbols.patch
		${FFMPEG_PATCH_URI}/0101-vulkan-decode-dpb-distinct-no-drm-modifiers.patch -> ${P}-ffmpeg-vulkan-dpb.patch
		${FFMPEG_PATCH_URI}/0102-vulkan-av1-clear-unused-ref-frame-mvs.patch -> ${P}-ffmpeg-av1-ref-mvs.patch
	)
"

S="${WORKDIR}"
LICENSE="BSD-2
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BZIP2 Boost-1.0 curl FTL
	GPL-2+ IJG LGPL-2.1+ LGPL-3 MIT MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+vulkan-video"
RESTRICT="strip"

RDEPEND="
	>=dev-libs/glib-2.80:2
	dev-libs/wayland
	media-fonts/liberation-fonts
	media-libs/libglvnd[X]
	media-libs/libpulse
	media-libs/vulkan-loader
	vulkan-video? (
		media-libs/dav1d:=
		media-libs/opus:=
		virtual/zlib:=
	)
	!vulkan-video? (
		>=media-video/ffmpeg-6
		<media-video/ffmpeg-10
	)
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
DEPEND="
	vulkan-video? (
		>=dev-util/vulkan-headers-1.4.317
		media-libs/dav1d:=
		media-libs/opus:=
		virtual/zlib:=
		x11-libs/libdrm
	)
"
BDEPEND="
	app-arch/xz-utils
	dev-util/patchelf
	vulkan-video? (
		dev-lang/nasm
		virtual/pkgconfig
	)
"

src_unpack() {
	unpack_deb "${MY_DEB}"
	if use vulkan-video; then
		unpack "ffmpeg-${FFMPEG_PV}.tar.xz"
	fi
}

src_prepare() {
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

	if use vulkan-video; then
		cd "ffmpeg-${FFMPEG_PV}" || die
		eapply "${DISTDIR}/${P}-ffmpeg-symbols.patch"
		eapply "${DISTDIR}/${P}-ffmpeg-vulkan-dpb.patch"
		eapply "${DISTDIR}/${P}-ffmpeg-av1-ref-mvs.patch"
		eapply "${FILESDIR}/ffmpeg-av1-vulkan-film-grain.patch"
		cd "${S}" || die
	fi

	eapply_user
}

src_configure() {
	use vulkan-video || return 0

	cd "ffmpeg-${FFMPEG_PV}" || die
	./configure \
		--prefix="${EPREFIX}/opt/ladybird" \
		--libdir="${EPREFIX}${FFMPEG_DIR}" \
		--cc="$(tc-getCC)" \
		--ar="$(tc-getAR)" \
		--nm="$(tc-getNM)" \
		--ranlib="$(tc-getRANLIB)" \
		--pkg-config="$(tc-getPKG_CONFIG)" \
		--extra-cflags="${CFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--enable-shared --disable-static --build-suffix=-ladybird \
		--disable-autodetect --disable-everything \
		--disable-programs --disable-doc \
		--disable-avdevice --disable-avfilter --disable-avformat \
		--disable-network --disable-swscale \
		--enable-libdav1d --enable-libdrm --enable-libopus --enable-vulkan --enable-zlib \
		--enable-decoder=av1,vp8,vp9,libdav1d,theora,vorbis,opus,flac,mp3float,pcm_u8,pcm_s16le,pcm_s24le,pcm_s32le,pcm_f32le,pcm_alaw,pcm_mulaw,h264,hevc,aac \
		--enable-parser=vp8,vp9,av1,mpegaudio \
		--enable-encoder=libopus \
		--enable-hwaccel=h264_vulkan,hevc_vulkan,av1_vulkan,vp9_vulkan || die
}

src_compile() {
	use vulkan-video || return 0

	emake -C "ffmpeg-${FFMPEG_PV}"
}

src_install() {
	sed -i 's|^Exec=/opt/ladybird/bin/Ladybird|Exec=/usr/bin/ladybird|' \
		usr/share/applications/org.ladybird.Ladybird.desktop \
		usr/share/dbus-1/services/org.ladybird.Ladybird.service || die

	dodir /opt /usr/bin /usr/share
	cp -a --no-preserve=ownership opt/ladybird "${ED}/opt/" || die
	cp -a --no-preserve=ownership usr/share/. "${ED}/usr/share/" || die
	install -m 0755 "${FILESDIR}/ladybird" "${ED}/usr/bin/ladybird" || die

	if use vulkan-video; then
		emake -C "ffmpeg-${FFMPEG_PV}" DESTDIR="${D}" install-libs
		local library
		for library in libavcodec-ladybird.so.63 libavutil-ladybird.so.61 libswresample-ladybird.so.7; do
			patchelf --set-rpath '$ORIGIN' "${ED}${FFMPEG_DIR}/${library}" || die
		done
		# The launcher uses this link to opt into the rebuilt FFmpeg.
		dosym ../libavcodec-ladybird.so.63 "${FFMPEG_DIR}/ffmpeg-9/libavcodec.so.63"

		local helper
		for helper in SystemProbe VideoDecoderServer; do
			mv "${ED}/opt/ladybird/libexec/${helper}" "${ED}/opt/ladybird/libexec/${helper}.real" || die
			install -m 0755 "${FILESDIR}/vulkan-helper" "${ED}/opt/ladybird/libexec/${helper}" || die
		done
	fi
}
