# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12,13,14} )

inherit desktop python-single-r1 xdg

DESCRIPTION="An easy-to-use AI text-generation software for GGML and GGUF models"
HOMEPAGE="https://github.com/LostRuins/koboldcpp"
SRC_URI="
	https://github.com/LostRuins/koboldcpp/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="AGPL-3.0-only MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="gui native vulkan"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	vulkan? (
		media-libs/vulkan-loader
	)
	gui? (
		$(python_gen_cond_dep '
			dev-python/customtkinter[${PYTHON_USEDEP}]
			dev-python/darkdetect[${PYTHON_USEDEP}]
		')
	)
	$(python_gen_cond_dep '
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"
BDEPEND="
	vulkan? (
		media-libs/shaderc
		dev-util/vulkan-headers
	)
"

S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default

	# Do not pre-strip binaries/libraries; Portage handles stripping.
	sed -i \
		-e 's/ -DNDEBUG -s/ -DNDEBUG/g' \
		Makefile || die
}


src_compile() {
	local myemakeargs=(
		$(usev native "LLAMA_NATIVE=1")
		$(usev vulkan "LLAMA_VULKAN=1")
	)

	if use vulkan; then
		# Prefer Gentoo's system glslc instead of upstream's bundled glslc-linux.
		myemakeargs+=( LLAMA_USE_BUNDLED_GLSLC= )
	fi

	emake "${myemakeargs[@]}"
}

src_install() {
	local dest="/usr/share/${PN}"

	# Native backends and Python entrypoint.
	insinto "${dest}"
	doins ./*.so
	doins json_to_gbnf.py
	doins koboldcpp.py

	# Embedded resources.
	insinto "${dest}/embd_res"
	doins embd_res/*

	# Adapter files.
	insinto "${dest}/kcpp_adapters"
	doins kcpp_adapters/*

	# Wrapper script.
	local wrapper="${T}/koboldcpp"
	cat > "${wrapper}" <<-EOF || die
		#!/bin/sh
		exec ${EPYTHON} /usr/share/${PN}/koboldcpp.py "\$@"
	EOF

	exeinto /usr/bin
	doexe "${wrapper}"

	# Desktop entry and icon.
	domenu "${FILESDIR}/${PN}.desktop"
	doicon -s 512 "${FILESDIR}/${PN}.png"

	# Licenses.
	dodoc LICENSE.md MIT_LICENSE_GGML_SDCPP_LLAMACPP_ONLY.md
}
