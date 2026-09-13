<div align="center">
  <h1>BITS Tailscale</h1>
  <p>
    <a href="https://bits.co.id">
      <img src="https://img.shields.io/badge/Banten%20IT%20Solutions-BITS%20Tailscale-00C853?style=for-the-badge&logo=tailscale&logoColor=white" alt="BITS Tailscale" />
    </a>
  </p>
  <p>
    Drop-in LuCI app for Tailscale on OpenWrt &mdash; manage your mesh VPN from the web interface with a modern BITS theme.
  </p>
  <br>
  <p>
    <img src="https://img.shields.io/badge/OpenWrt-00A1E9?style=flat&logo=openwrt&logoColor=white" alt="OpenWrt" />
    <img src="https://img.shields.io/badge/LuCI-3D5780?style=flat" alt="LuCI" />
    <img src="https://img.shields.io/badge/Tailscale-242424?style=flat&logo=tailscale&logoColor=white" alt="Tailscale" />
    <img src="https://img.shields.io/badge/WireGuard-88171A?style=flat&logo=wireguard&logoColor=white" alt="WireGuard" />
    <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black" alt="JavaScript" />
    <img src="https://img.shields.io/badge/license-MIT-green?style=flat" alt="MIT License" />
  </p>
</div>

---

## ✨ Features

| Feature                   | Description                                                                                                     |
| ------------------------- | --------------------------------------------------------------------------------------------------------------- |
| **Global Settings**       | `Connected` / `Disconnected` status pill with blinking dot, themed via `bits.css`.                              |
| **Interface Info**        | `Network Interface Information` rendered as a card (`ifacebox`), consistent with the native *Routes* page.      |
| **Logs Viewer**           | Tailscale daemon logs with *Scroll to tail / head* buttons and symmetric margins.                               |
| **Page Title Fix**        | Each page title is rendered via `form.Map(config, title)` so it no longer disappears.                          |
| **ACL Logread Fix**       | ACL allows `logread` on both OpenWrt 22.03 (`/sbin/logread`) and 24.10 (`/usr/libexec/logread-ubox`) &mdash; prevents `PermissionError: Access to command denied by ACL`. |
| **Binary Auto-install**   | Package `Depends: tailscale`, so `opkg` pulls the official binary automatically.                               |
| **Official Latest**       | `postinst` best-effort upgrades the binary via `tailscale update` (non-fatal).                                  |
| **Automated Release**     | semantic-release builds the `.ipk` and publishes a GitHub Release on every conventional commit.                 |

## 🛠️ Tech Stack

| Layer        | Technology                                                                        |
| ------------ | --------------------------------------------------------------------------------- |
| **Runtime**  | OpenWrt (LuCI)                                                                    |
| **Backend**  | `rpcd` ACL, `uci-defaults`, `hotplug.d`                                           |
| **Language** | JavaScript (LuCI AMD views loaded via `require`)                                  |
| **Theme**    | BITS theme (`bits.css`, `bits-icons.js`)                                          |
| **Build**    | OpenWrt build system (`luci.mk`) via SDK                                       |
| **Release**  | semantic-release + GitHub Actions                                                 |

---

## 📁 Project Structure

```text
BITS-Tailscale/
├── .github/
│   ├── dependabot.yml             # dep update (npm + actions)
│   └── workflows/
│       └── release.yml            # semantic-release + build .ipk/.apk + attach asset
├── luci-app-bitstailscale/
│   ├── Makefile                   # OpenWrt package def (luci.mk) + postinst
│   ├── htdocs/
│   │   └── luci-static/resources/view/bitstailscale/
│   │       ├── interface.js       # Global Settings + Interface Info
│   │       ├── log.js             # Logs viewer
│   │       ├── setting.js         # Status pill + BITS theme
│   │       └── style.css          # local view styles
│   └── root/
│       ├── etc/hotplug.d/iface/40-tailscale
│       ├── etc/uci-defaults/40_luci-tailscale
│       └── usr/share/
│           ├── luci/menu.d/luci-app-bitstailscale.json
│           └── rpcd/acl.d/luci-app-bitstailscale.json
├── scripts/
│   └── prepare.js                 # sync version (package.json + lockfile + Makefile)
├── package.json                   # semantic-release + plugins
├── package-lock.json              # npm lockfile (npm ci)
├── .releaserc.json                # release plugins (git + github)
└── LICENSE
```

---

## 🚀 Quick Start

### Prerequisites

- An OpenWrt device (22.03+), with the `luci` feed installed
- Internet access for the `tailscale` binary

### 1. Download

Grab the package from the [Releases](https://github.com/Banten-IT-Solutions/BITS-Tailscale/releases) page, then copy it to your device:
- `.ipk` for OpenWrt 22.03–24.10 (`opkg`)
- `.apk` for OpenWrt 25.12+ (`apk`)

### 2. Install

```sh
# OpenWrt 22.03–24.10 (opkg)
opkg install luci-app-bitstailscale_<version>_all.ipk

# OpenWrt 25.12+ (apk)
apk add luci-app-bitstailscale_<version>_all.apk
```

`tailscale` (binary) is installed automatically via the package dependency. To force the latest official binary:

```sh
tailscale update
```

### 3. Use

Open LuCI (`Services → BITS Tailscale`) and sign in with your Tailscale account.

---

## 🏗️ Build

Build lewat OpenWrt build system. Copy package folder ke `feeds/luci/applications/`, lalu:

```sh
./scripts/feeds update -a
./scripts/feeds install luci-app-bitstailscale
make menuconfig   # LuCI -> Applications -> luci-app-bitstailscale
make package/luci-app-bitstailscale/compile
```

---

## 🚀 Release

Releases are automated with [semantic-release](https://semantic-release.gitbook.io) and [Conventional Commits](https://www.conventionalcommits.org). Write a conventional commit:

| Commit                           | Bump       |
| -------------------------------- | ---------- |
| `fix: ...`                       | patch      |
| `feat: ...`                      | minor      |
| `BREAKING CHANGE:` in body       | major      |

Push to `main` dan workflow build `.ipk` (openwrt-24.10) + `.apk` (openwrt-25.12) lalu publish ke GitHub Release.

### 🔏 Signing

Paket di-build **signed** untuk feed distribusi. Butuh dua secret:

| Secret             | Format             | Untuk            |
| ------------------ | ------------------ | ---------------- |
| `KEY_BUILD`        | usign secret key   | `.ipk` (24.10)   |
| `APK_PRIVATE_KEY`  | ed25519 PEM        | `.apk` (25.12)   |

Generate key:

```sh
# ipk (usign) — pakai `usign` dari OpenWrt (`opkg install usign`) atau SDK: `staging_dir/host/bin/usign`
usign -G -s key-build -p key-build.pub -c "BITS Tailscale"

# apk (ed25519 PEM) + turunan public key
openssl genpkey -algorithm ed25519 -out private-key.pem
openssl pkey -in private-key.pem -pubout -out public-key.pem
```

Taruh isi `key-build` → secret `KEY_BUILD`, isi `private-key.pem` → secret `APK_PRIVATE_KEY`. Public key (`key-build.pub` / `public-key.pem`) dipasang di device/feed untuk verifikasi. Signing switch per-branch otomatis; secret kosong → branch itu unsigned (tidak gagal).

---

## 📄 License

Distributed under the MIT License. See `LICENSE`.

---

<div align="center">
  <strong>BITS Tailscale</strong> Developed with ❤️ by <a href="https://bits.co.id"><strong>Banten IT Solutions</strong></a>
</div>
