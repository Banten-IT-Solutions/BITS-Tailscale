# SPDX-License-Identifier: MIT
#
# Tailscale LuCI app
# Dibangun lewat OpenWrt build system (feeds/luci). Letakkan folder ini di
# feeds/luci/applications/luci-app-tailscale lalu pilih di menuconfig
# (LuCI -> Applications -> luci-app-tailscale).

include $(TOPDIR)/rules.mk

LUCI_TITLE:=Tailscale
LUCI_DEPENDS:=+tailscale
LUCI_PKGARCH:=all

PKG_LICENSE:=MIT
PKG_MAINTAINER:=Banten IT Solutions <support@bits.co.id>
PKG_VERSION:=1.0.2
PKG_RELEASE:=1

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature file