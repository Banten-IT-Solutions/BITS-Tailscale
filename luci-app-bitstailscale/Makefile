# SPDX-License-Identifier: MIT
#
# Tailscale LuCI app
# Dibangun lewat OpenWrt build system (feeds/luci). Letakkan folder ini di
# feeds/luci/applications/luci-app-bitstailscale lalu pilih di menuconfig
# (LuCI -> Applications -> luci-app-bitstailscale).

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Tailscale
LUCI_DEPENDS:=tailscale
LUCI_PKGARCH:=all

PKG_LICENSE:=MIT
PKG_MAINTAINER:=Banten IT Solutions <support@bits.co.id>
PKG_VERSION:=1.1.1
PKG_RELEASE:=1

# Postinst kustom: cache clear + rpcd reload (sama dgn luci.mk default) +
# tailscale update best-effort. Menimpa default luci.mk biar apk & ipk parity.
define Package/$(PKG_NAME)/postinst
[ -n "$${IPKG_INSTROOT}" ] && exit 0
rm -f /tmp/luci-indexcache.*
rm -rf /tmp/luci-modulecache/
/etc/init.d/rpcd reload 2>/dev/null
[ -x /usr/sbin/tailscale ] && ( tailscale update >/dev/null 2>&1 & )
exit 0
endef

# Config daemon tailscale jangan ditimpa saat upgrade.
define Package/$(PKG_NAME)/conffiles
/etc/config/tailscale
endef

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature file