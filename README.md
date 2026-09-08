# luci-app-tailscale

LuCI app untuk [Tailscale](https://tailscale.com) — antarmuka pengelolaan Tailscale di OpenWrt yang ringkas dan modern. Drop-in pengganti `luci-app-tailscale` bawaan.

## Fitur

- **Global Settings** dengan status `Connected` / `Disconnected` bergaya pill + indikator titik berkedip.
- **Interface Info** menampilkan tabel `Network Interface Information` bergaya kartu (`ifacebox`), konsisten dengan halaman *Routes* bawaan LuCI.
- **Logs** dengan tombol *Scroll to tail / head* yang rapi (margin simetris).
- Title halaman konsisten di atas tab.
- Perbaikan ACL: path `logread` mendukung OpenWrt 22.03 (`/sbin/logread`) **dan** 24.10 (`/usr/libexec/logread-ubox`) — mencegah `PermissionError: Access to command denied by ACL`.
- **Auto-install binary Tailscale**: paket ini `Depends: tailscale`, jadi `opkg` otomatis menarik binary resmi Tailscale saat instalasi.
- **Official latest**: `postinst` berusaha menaikkan binary ke rilisan resmi terbaru via `tailscale update` (best-effort, non-fatal).

## Install

Dari rilis `.ipk` di laman [Releases](https://github.com/bitscoid/bits-tailscale/releases):

```sh
# pastikan feed resmi OpenWrt aktif, lalu:
opkg install luci-app-tailscale_1.0.0_all.ipk
```

`tailscale` (binary) akan ikut terpasang otomatis. Bila ingin memaksa versi resmi terbaru:

```sh
tailscale update
```

## Build

### Tanpa SDK (langsung jadi `.ipk`)

```sh
./build.sh
# output: dist/luci-app-tailscale_<versi>_all.ipk
```

Cukup `bash` + `tar` — tidak butuh toolchain. (Format `.ipk` OpenWrt adalah `tar.gz` luar berisi `./debian-binary` + `./control.tar.gz` + `./data.tar.gz`.)

### Dengan OpenWrt build system

Salin folder paket ke `feeds/luci/applications/`, lalu:

```sh
./scripts/feeds update -a
./scripts/feeds install luci-app-tailscale
make menuconfig   # LuCI -> Applications -> luci-app-tailscale
make package/luci-app-tailscale/compile
```

## Release otomatis (semantic-release)

Rilis memakai [semantic-release](https://semantic-release.gitbook.io) dengan [Conventional Commits](https://www.conventionalcommits.org). Cukup tulis pesan commit konvensional:

- `fix: ...` → bump patch (1.0.x)
- `feat: ...` → bump minor (1.x.0)
- `BREAKING CHANGE:` di body → bump major (x.0.0)

Push ke `main` akan membangun `.ipk` dan membuat GitHub Release dengan asetnya.

## Struktur proyek

```
.
├── .github/workflows/release.yml   # semantic-release + build .ipk
├── luci-app-tailscale/
│   ├── Makefile                    # definisi paket OpenWrt (luci.mk)
│   ├── htdocs/…/view/tailscale/    # interface.js, log.js, setting.js, style.css
│   └── root/                       # ACL, menu, hotplug, uci-defaults
├── control                         # metadata ipk
├── postinst                        # reload ACL/menu + tailscale update (best-effort)
├── scripts/prepare.js              # sinkronisasi versi + build (dipakai semantic-release)
├── build.sh                        # packer .ipk tanpa SDK
└── LICENSE
```

## Lisensi

[MIT](LICENSE). Dibangun di atas `luci-app-tailscale` (asvow) dan komponen LuCI.