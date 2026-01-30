# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages. CJK Sans OTF variant"
HOMEPAGE="https://fonts.google.com/noto https://github.com/notofonts/notofonts.github.io"

SRC_URI="https://github.com/notofonts/noto-cjk/releases/download/Sans${PV}/04_NotoSansCJK-OTF.zip -> ${P}.zip"
S="${WORKDIR}/OTF"

LICENSE="OFL-1.1"
SLOT="0"
# Technically any
KEYWORDS="amd64"

RESTRICT="binchecks strip"

FONT_SUFFIX="otf"


src_install() {
	mkdir install-unhinted || die
	mv */*.otf install-unhinted/. || die

	FONT_S="${S}/install-unhinted/" font_src_install
}
