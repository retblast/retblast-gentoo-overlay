# Copyright 2026 The Gentoo Authors


EAPI=8

inherit git-r3 autotools
EGIT_REPO_URI="https://github.com/maciejwieczorretman/intel-lpmd.git"
EGIT_BRANCH="main_issue_106"
# Fork that fixes the issue #106
DESCRIPTION="Intel Low Power Mode Daemon (lpmd) is a Linux daemon designed to optimize active idle power."
SLOT="0"
KEYWORDS="~amd64"
LICENSE="GPL-2"
IUSE="doc"

BDEPEND="
    dev-build/autoconf
    dev-build/autoconf-archive
    dev-build/automake
    dev-build/libtool
    virtual/pkgconfig
    doc? ( dev-util/gtk-doc )
"
DEPEND="
    dev-libs/glib:2
    dev-libs/libxml2
    net-libs/libnl:3
    sys-apps/systemd
    sys-power/upower
"

RDEPEND="
    ${DEPEND}
    sys-apps/systemd
"

src_prepare() {
    default
    eautoreconf
}

src_configure() {
    econf \
        --localstatedir=/var \
        --sysconfdir=/etc
}

src_install() {
    emake DESTDIR="${D}" install
    rm "${D}/usr/share/man/man8/intel_lpmd.8.gz"
}

pkg_postinst() {
    elog "To start intel-lpmd, run:"
    elog "  systemctl enable --now intel_lpmd.service"
    elog ""
    elog "Requires an Intel Hybrid CPU (ADL/RPL/MTL/LNL/PTL)."
}