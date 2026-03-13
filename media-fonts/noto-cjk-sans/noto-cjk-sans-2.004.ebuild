# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit font

DESCRIPTION="Google's font family that aims to support all the world's languages. CJK Sans OTF variant"
HOMEPAGE="https://fonts.google.com/noto https://github.com/notofonts/notofonts.github.io"

SRC_URI="https://github.com/notofonts/noto-cjk/releases/download/Sans${PV}/02_NotoSansCJK-TTF-VF.zip -> ${P}.zip"
S="${WORKDIR}/Variable/TTF"

LICENSE="OFL-1.1"
SLOT="0"
# Technically any
KEYWORDS="amd64"

RESTRICT="binchecks strip"

FONT_SUFFIX="ttf"

src_install() {
	mkdir install-hinted-variable || die
	mv */*.ttf install-hinted-variable/. || die

	FONT_S="${S}/install-hinted-variable/" font_src_install
