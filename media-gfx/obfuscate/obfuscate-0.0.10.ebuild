# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

# Eclasses tend to list descriptions of how to use their functions properly.
# Take a look at the eclass/ directory for more examples.

CRATES="
	aho-corasick@1.1.3
	anyhow@1.0.81
	autocfg@1.1.0
	bitflags@2.5.0
	block@0.1.6
	cairo-rs@0.19.2
	cairo-sys-rs@0.19.2
	cc@1.0.90
	cfg-expr@0.15.7
	env_logger@0.10.2
	equivalent@1.0.1
	field-offset@0.3.6
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-io@0.3.30
	futures-macro@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	gdk-pixbuf-sys@0.19.0
	gdk-pixbuf@0.19.2
	gdk4-sys@0.8.1
	gdk4@0.8.1
	gettext-rs@0.7.0
	gettext-sys@0.21.3
	gio-sys@0.19.0
	gio@0.19.3
	glib-macros@0.19.3
	glib-sys@0.19.0
	glib@0.19.3
	gobject-sys@0.19.0
	graphene-rs@0.19.2
	graphene-sys@0.19.0
	gsk4-sys@0.8.1
	gsk4@0.8.1
	gtk4-macros@0.8.1
	gtk4-sys@0.8.1
	gtk4@0.8.1
	hashbrown@0.14.3
	heck@0.5.0
	hermit-abi@0.3.9
	humantime@2.1.0
	indexmap@2.2.6
	is-terminal@0.4.12
	lazy_static@1.4.0
	libadwaita-sys@0.6.0
	libadwaita@0.6.0
	libc@0.2.153
	locale_config@0.3.0
	log@0.4.21
	malloc_buf@0.0.6
	memchr@2.7.1
	memoffset@0.9.0
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	pango-sys@0.19.0
	pango@0.19.3
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.30
	pretty_env_logger@0.5.0
	proc-macro-crate@3.1.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.79
	quote@1.0.35
	regex-automata@0.4.6
	regex-syntax@0.8.2
	regex@1.10.4
	rustc_version@0.4.0
	semver@1.0.22
	serde@1.0.197
	serde_derive@1.0.197
	serde_spanned@0.6.5
	slab@0.4.9
	smallvec@1.13.2
	syn@1.0.109
	syn@2.0.55
	system-deps@6.2.2
	target-lexicon@0.12.14
	temp-dir@0.1.13
	termcolor@1.4.1
	thiserror-impl@1.0.58
	thiserror@1.0.58
	toml@0.8.12
	toml_datetime@0.6.5
	toml_edit@0.21.1
	toml_edit@0.22.9
	unicode-ident@1.0.12
	version-compare@0.2.0
	version_check@0.9.4
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.52.0
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.52.4
	winnow@0.5.40
	winnow@0.6.5
"

inherit cargo meson gnome2-utils

# Short one-line description of this package.
DESCRIPTION="Censor private information."

# Homepage, not used by Portage directly but handy for developer reference
HOMEPAGE="https://gitlab.gnome.org/World/obfuscate"

# Point to any required sources; these will be automatically downloaded by
# Portage.
SRC_URI="
  https://gitlab.gnome.org/World/obfuscate/-/archive/${PV}/${P}.tar.gz
  ${CARGO_CRATE_URIS}
"

PATCHES=(
  "${FILESDIR}"/obfuscate-dbus-activatable.patch
  "${FILESDIR}"/obfuscate-new-window.patch
)

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
  >=gnome-base/dconf-0.40.0
  >=sys-devel/gcc-15.2.1_p20251122
  >=dev-libs/glib-2.84.4
  >=sys-libs/glibc-2.41-r6
  >=media-libs/graphene-1.10.8-r1
  >=gui-libs/gtk-4.18.6-r1
  >=x11-themes/hicolor-icon-theme-0.17
  >=gui-libs/libadwaita-1.7.7-r1
"
DEPEND="
  ${RDEPEND}
  >=dev-libs/appstream-1.0.6
  >=dev-vcs/git-2.52.0
  >=dev-build/meson-1.9.1
  >=dev-lang/rust-bin-1.91.0
"

# Rust
QA_FLAGS_IGNORED="usr/bin/obfuscate"

src_prepare() {
  default
  cargo_src_unpack
  git cherry-pick -n c1999aef671e68ed52017047715bb178c13190e2
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
  ln -s "${CARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}