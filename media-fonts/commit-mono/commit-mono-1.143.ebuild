# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{12..14} )

inherit font python-any-r1


MY_PN="CommitMono"
DESCRIPTION="Anonymous and neutral programming typeface focused on creating a better reading experience"
HOMEPAGE="https://commitmono.com/"
SRC_URI="https://github.com/eigilnikolajsen/${PN}/releases/download/v${PV}/${MY_PN}-${PV}.zip -> ${P}.zip"

LICENSE="OFL-1.1"
SLOT="0"

# To bake in the opentype features
# Kinda stupid, but hey, this is for myself
BDEPEND+="
  app-text/opentype-feature-freezer
  $(python_gen_any_dep 'dev-python/fonttools[${PYTHON_USEDEP}]')

  app-shells/fish
  app-arch/unzip
"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86 ~x64-macos"

FONT_SUFFIX="ttf"
RESTRICT="binchecks strip"

S="${WORKDIR}/${MY_PN}-${PV}/ttfautohint"

python_check_deps() {
	python_has_version "dev-python/fonttools[${PYTHON_USEDEP}]"
}

src_prepare() {
    default

    ${FILESDIR}/bake-opentype-features.fish --srcPath=$PWD --localPath=$PWD --inputFontFormat=ttf
    local font
	for font in ./*.ttf ./*.otf; do
		[[ -e ${font} ]] || continue
		"${PYTHON}" "${FILESDIR}/bake-line-height.py" "${font}" || die
	done

    
}
