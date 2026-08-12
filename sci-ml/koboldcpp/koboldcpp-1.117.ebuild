# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit desktop python-single-r1

DESCRIPTION="An easy-to-use AI text-generation software for GGML and GGUF models"
HOMEPAGE="https://github.com/LostRuins/koboldcpp"
SRC_URI="https://github.com/LostRuins/koboldcpp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3 MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gui portable"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	media-libs/vulkan-loader
	dev-util/vulkan-headers
"
RDEPEND="
	${PYTHON_DEPS}
	media-libs/vulkan-loader
	$(python_gen_cond_dep '
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/jinja[${PYTHON_USEDEP}]
	')
	gui? (
		$(python_gen_cond_dep '
			dev-python/customtkinter[${PYTHON_USEDEP}]
			dev-python/darkdetect[${PYTHON_USEDEP}]
		')
		gnome-extra/zenity
	)
"
BDEPEND="media-libs/shaderc"

src_compile() {
	# portable: build the AVX2/AVX/failsafe SIMD ladder so the result runs
	# on any x86_64 box. Off: -march=native, tuned to this host only.
	emake LLAMA_VULKAN=1 $(usev portable LLAMA_PORTABLE=1)
}

src_install() {
	insinto /usr/share/koboldcpp
	doins ./*.so
	doins json_to_gbnf.py koboldcpp.py

	insinto /usr/share/koboldcpp/embd_res
	doins embd_res/*

	insinto /usr/share/koboldcpp/kcpp_adapters
	doins kcpp_adapters/*

	# thin launcher pinned to the selected Python impl
	cat > "${T}"/koboldcpp <<-EOF || die
		#!/bin/sh
		exec ${EPYTHON} /usr/share/koboldcpp/koboldcpp.py "\$@"
	EOF
	dobin "${T}"/koboldcpp

	domenu "${FILESDIR}"/koboldcpp.desktop
	newicon -s 512 "${FILESDIR}"/koboldcpp.png koboldcpp.png
}
