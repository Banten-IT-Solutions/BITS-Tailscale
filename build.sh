#!/usr/bin/env bash
# Pack luci-app-bitstailscale: .ipk (opkg) + .apk (apk) tanpa OpenWrt SDK.
# .ipk = tar.gz luar (debian-binary + control.tar.gz + data.tar.gz)
# .apk = apk-tools v3 `mkpkg` (butuh binary `apk` di PATH / env APK_BIN)
set -euo pipefail

PKG_NAME=luci-app-bitstailscale
PKG_VER=$(awk -F': ' '/^Version:/{print $2; exit}' control)
PKG_DESC=$(awk -F': ' '/^Description:/{print $2; exit}' control)
PKG_DEPENDS=$(awk -F': ' '/^Depends:/{print $2; exit}' control | tr ',' ' ')

OUT_IPK="dist/${PKG_NAME}_${PKG_VER}_all.ipk"
OUT_APK="dist/${PKG_NAME}_${PKG_VER}_all.apk"

rm -rf .build dist
mkdir -p .build/root .build/control .build/outer dist

# htdocs -> /www ; root -> /
cp -a luci-app-bitstailscale/htdocs/. .build/root/www/
cp -a luci-app-bitstailscale/root/.   .build/root/

# ===== .ipk (opkg) =====
cp control .build/control/control
if [ -f postinst ]; then
  cp postinst .build/control/postinst
  chmod 755 .build/control/postinst
fi
if [ -f conffiles ]; then
  cp conffiles .build/control/conffiles
fi

tar czf .build/data.tar.gz --owner=0 --group=0 -C .build/root .
tar czf .build/control.tar.gz --owner=0 --group=0 -C .build/control .
printf '2.0\n' > .build/debian-binary

cp .build/debian-binary .build/control.tar.gz .build/data.tar.gz .build/outer/
tar czf "$OUT_IPK" -C .build/outer .

# ===== .apk (apk-tools v3) =====
APK_BIN="${APK_BIN:-apk}"
if command -v "$APK_BIN" >/dev/null 2>&1; then
  APK_ARGS=(
    mkpkg
    --info "name:${PKG_NAME}"
    --info "version:${PKG_VER}-r0"
    --info "arch:noarch"
    --info "description:${PKG_DESC}"
    --info "license:MIT"
    --info "maintainer:Banten IT Solutions <support@bits.co.id>"
    --info "depends:${PKG_DEPENDS}"
  )
  if [ -f postinst ]; then
    APK_ARGS+=(--script "post-install:postinst")
  fi
  APK_ARGS+=(--files .build/root --output "$OUT_APK")
  "$APK_BIN" "${APK_ARGS[@]}"
  echo "Built: $OUT_APK"
else
  echo "skip .apk: binary 'apk' not found (set APK_BIN)"
fi

rm -rf .build
echo "Built: $OUT_IPK"