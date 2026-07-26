EAPI=8

inherit multilib toolchain-funcs flag-o-matic

DESCRIPTION="Fraunhofer xHE-AAC (MPEG-D USAC) encoder library from AOSP, for FFmpeg's libxheaacenc encoder"
HOMEPAGE="https://android.googlesource.com/platform/external/aac"

# AOSP tag this is pulled from -- kept separate from PV since Gentoo version
# syntax doesn't cleanly accommodate the "_r1" AOSP suffix.
MY_TAG="android-17.0.0_r1"
SRC_URI="https://android.googlesource.com/platform/external/aac/+archive/refs/tags/${MY_TAG}/xhe-aac.tar.gz -> ${P}.tar.gz"

# The gitiles archive endpoint extracts the *contents* of the requested path
# directly at the tarball root (no wrapping directory), so S = WORKDIR.
S="${WORKDIR}"

LICENSE="Fraunhofer-xHEAAC-Android"
SLOT="0"
KEYWORDS="*"
IUSE=""

# Not an official Gentoo/upstream-mirrored distfile -- always fetch straight
# from android.googlesource.com, don't bother trying Gentoo mirrors first.
RESTRICT="mirror"

src_compile() {
	append-cflags -fPIC

	emake -f "${FILESDIR}"/Makefile \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		CFLAGS="${CFLAGS}"
}

src_install() {
	dolib.a libFraunhoferXHEAACEnc.a

	insinto /usr/include
	doins xHEAACEnc/include/xHEAACEnc.h

	cat > "${T}"/libxheaacenc.pc <<-EOF
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include

		Name: libxheaacenc
		Description: ${DESCRIPTION}
		Version: ${PV}
		Libs: -L\${libdir} -lFraunhoferXHEAACEnc -lm
		Cflags: -I\${includedir}
	EOF

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${T}"/libxheaacenc.pc
}
