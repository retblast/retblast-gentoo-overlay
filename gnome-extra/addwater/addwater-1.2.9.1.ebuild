# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
inherit meson gnome2-utils

DESCRIPTION=" Installer for the Firefox GNOME theme."
HOMEPAGE="https://github.com/largestgithubuseronearth/addwater"
SRC_URI="https://github.com/largestgithubuseronearth/${PN}/archive/refs/tags/v${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"
BDEPEND="
  dev-build/meson
  dev-build/ninja
  dev-util/glib-utils
  dev-util/gtk-update-icon-cache
  sys-devel/gettext
"

RDEPEND="
  dev-lang/python:3
  dev-python/pygobject
  gui-libs/gtk:4
  gui-libs/libadwaita
  dev-libs/glib
  dev-libs/libportal[gtk4]
  dev-python/requests
  dev-python/packaging
"
src_prepare() {
  default
}
src_configure() {
  if use debug; then
    PROFILE_TYPE="development"
  else
    PROFILE_TYPE="default"
  fi

  local emesonargs=(
    -Dprofile="${PROFILE_TYPE}"
  )
  meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}