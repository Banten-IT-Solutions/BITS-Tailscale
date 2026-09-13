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
| **Global Settings**       | `Connected` / `Disconnected` status pill with blinking dot, styled via portable `style.css`.                    |
| **Interface Info**        | `Network Interface Information` rendered as a card (`ifacebox`), consistent with the native *Routes* page.      |
| **Logs Viewer**           | Tailscale daemon logs with *Scroll to tail / head* buttons and symmetric margins.                               |
| **Page Title Fix**        | Each page title is rendered via `form.Map(config, title)` so it no longer disappears.                          |
| **ACL Logread Fix**       | ACL allows `logread` on both OpenWrt 22.03 (`/sbin/logread`) and 24.10 (`/usr/libexec/logread-ubox`) &mdash; prevents `PermissionError: Access to command denied by ACL`. |
| **Binary Auto-install**   | Package `Depends: tailscale`, so `opkg` / `apk` pulls the official binary automatically.                       |
| **Official Latest**       | `postinst` best-effort upgrades the binary via `tailscale update` (non-fatal).                                  |
| **Automated Release**     | semantic-release builds `.ipk` + `.apk` and publishes a GitHub Release on every conventional commit.            |

## 🛠️ Tech Stack

| Layer        | Technology                                                                        |
| ------------ | --------------------------------------------------------------------------------- |
| **Runtime**  | OpenWrt (LuCI)                                                                    |
| **Backend**  | `rpcd` ACL, `uci-defaults`, `hotplug.d`                                           |
| **Language** | JavaScript (LuCI AMD views loaded via `require`)                                  |
| **Theme**    | Portable `style.css` (status pill + dark mode)                                    |
| **Build**    | `bash` + `tar` (ipk) + `apk-tools v3` (apk) — no SDK                       |
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
│   ├── Makefile                   # OpenWrt package def (luci.mk) — buat build manual
│   ├── htdocs/
│   │   └── luci-static/resources/view/bitstailscale/
│   │       ├── interface.js       # Interface Info
│   │       ├── log.js             # Logs viewer
│   │       ├── setting.js         # Global Settings form + status pill
│   │       └── style.css          # portable view styles
│   └── root/
│       ├── etc/
│       │   ├── config/tailscale
│       │   ├── hotplug.d/iface/40-tailscale
│       │   ├── init.d/tailscale
│       │   └── uci-defaults/40_luci-tailscale
│       └── usr/
│           ├── sbin/tailscale_helper
│           └── share/
│               ├── luci/menu.d/luci-app-bitstailscale.json
│               └── rpcd/acl.d/luci-app-bitstailscale.json
├── scripts/
│   └── prepare.js                 # sync version + build .ipk (semantic-release)
├── build.sh                       # SDK-less .ipk + .apk packer (bash + tar + apk-tools)
├── control                        # ipk metadata
├── postinst                       # reload ACL/menu + tailscale update
├── conffiles                      # jangan timpa /etc/config/tailscale saat upgrade
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

Grab package dari [Releases](https://github.com/Banten-IT-Solutions/BITS-Tailscale/releases), lalu copy ke device:
- `.ipk` untuk OpenWrt 22.03–24.10 (`opkg`)
- `.apk` untuk OpenWrt 25.12+ (`apk`)

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

### Option A — SDK-less `.ipk` + `.apk` (cepat)

Butuh `apk-tools v3` (`apk mkpkg`) di `PATH`. Di CI sudah di-cache; lokal install `apk-tools` 3.x atau set `APK_BIN=<path/to/apk>`.

```sh
./build.sh
# output: dist/luci-app-bitstailscale_<version>_all.ipk
#         dist/luci-app-bitstailscale_<version>_all.apk
```

> `.ipk` = outer `tar.gz` (debian-binary + control.tar.gz + data.tar.gz). `.apk` = ADB container via `apk mkpkg`.

### Option B — OpenWrt build system (buildroot lengkap)

Copy package folder ke `feeds/luci/applications/`, lalu:

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

Push to `main` dan workflow build `.ipk` + `.apk` (build.sh + apk-tools) lalu publish ke GitHub Release.

---

## 📄 License

Distributed under the MIT License. See `LICENSE`.

---

<div align="center">
  <strong>BITS Tailscale</strong> Developed with ❤️ by <a href="https://bits.co.id"><strong>Banten IT Solutions</strong></a>
</div>
