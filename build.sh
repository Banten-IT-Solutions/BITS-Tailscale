#!/usr/bin/env bash
# Pack luci-app-bitstailscale menjadi .ipk tanpa OpenWrt SDK.
# Format ipk OpenWrt = tar.gz luar berisi ./debian-binary + ./control.tar.gz + ./data.tar.gz.
set -euo pipefail

PKG_NAME=luci-app-bitstailscale
PKG_VER=$(awk -F': ' '/^Version:/{print $2; exit}' control)
OUT="dist/${PKG_NAME}_${PKG_VER}_all.ipk"

rm -rf .build dist
mkdir -p .build/root .build/control .build/outer dist

# htdocs -> /www ; root -> /
cp -a luci-app-bitstailscale/htdocs/. .build/root/www/
cp -a luci-app-bitstailscale/root/.   .build/root/

# control + optional postinst + conffiles
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
tar czf "$OUT" -C .build/outer .

rm -rf .build
echo "Built: $OUT"