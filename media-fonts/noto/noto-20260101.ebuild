# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages. OTF variant"
HOMEPAGE="https://fonts.google.com/noto https://github.com/notofonts/notofonts.github.io"

# Have to update this with each "release"
COMMIT="e3bdd5e75581e2b46d93343ec98594f3c89669c0"
SRC_URI="https://github.com/notofonts/notofonts.github.io/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/notofonts.github.io-${COMMIT}"

LICENSE="OFL-1.1"
SLOT="0"
# Technically any
KEYWORDS="amd64"

RESTRICT="binchecks strip"

FONT_SUFFIX="otf"
# TODO: Do I care?
# FONT_CONF=(
	# From ArchLinux
	# "${FILESDIR}/66-noto-serif.conf"
	# "${FILESDIR}/66-noto-mono.conf"
	#"${FILESDIR}/66-noto-sans.conf"
# )

src_install() {
	mkdir install-unhinted || die
	mv fonts/*/unhinted/otf/*.otf install-unhinted/. || die

	FONT_S="${S}/install-unhinted/" font_src_install
}
