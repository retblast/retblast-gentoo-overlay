# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
inherit vala meson gnome2-utils xdg

# Short one-line description of this package.
DESCRIPTION="A simple Wine and Proton-based compatibility tools manager for GNOME."

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://github.com/Vysp3r/ProtonPlus"

# Point to any required sources; these will be automatically downloaded by
# Portage.
SRC_URI="${HOMEPAGE}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="GPL-3+"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
  >=gui-libs/gtk-4.18.6-r1
  >=dev-libs/json-glib-1.10.8
  >=gui-libs/libadwaita-1.7.7-r1
  >=app-arch/libarchive-3.8.3
  >=dev-libs/libgee-0.20.8
  >=net-libs/libsoup-2.74.3-r1
  >=net-libs/libsoup-3.6.5-r1
"
DEPEND="
  ${RDEPEND}
  >=dev-build/meson-1.9.1
  >=dev-lang/vala-0.56.18
  ${vala_depend}
"
#TODO: Arch supports check(), idk how that is on Gentoo

# Rust
QA_FLAGS_IGNORED="usr/bin/protonplus"

# For some reason it extracts to ProtonPlus-<version>
S="${WORKDIR}/ProtonPlus-${PV}"

src_prepare() {
  default
  vala_setup
  xdg_environment_reset
}

src_configure() {
  meson_src_configure
}

pkg_preinst() {
  xdg_pkg_preinst
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}