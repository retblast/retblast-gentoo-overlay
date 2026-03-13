# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

MY_PN="CommitMono"
DESCRIPTION="Anonymous and neutral programming typeface focused on creating a better reading experience"
HOMEPAGE="https://commitmono.com/"
SRC_URI="https://github.com/eigilnikolajsen/${PN}/releases/download/v${PV}/${MY_PN}-${PV}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"

# To bake in the opentype features
BDEPEND="
  app-text/opentype-feature-freezer
  dev-python/fonttools
  # Kinda stupid, but hey, this is for myself
  app-shells/fish
"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos"

FONT_SUFFIX="ttf"
RESTRICT="binchecks strip"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_PN}-${PV}/ttfautohint"

src_prepare() {
    default

    ${FILESDIR}/bake-opentype-features.fish --srcPath=$PWD --localPath=$PWD --inputFontFormat=ttf
    
}