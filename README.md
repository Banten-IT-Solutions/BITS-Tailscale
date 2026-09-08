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
| **Build**    | `bash` + `tar` (no SDK), OpenWrt build system (`luci.mk`)                         |
| **Release**  | semantic-release + GitHub Actions                                                 |

---

## 📁 Project Structure

```text
BITS-Tailscale/
├── .github/
│   └── workflows/
│       └── release.yml            # semantic-release + build .ipk + attach asset
├── luci-app-tailscale/
│   ├── Makefile                   # OpenWrt package def (luci.mk)
│   ├── htdocs/
│   │   └── luci-static/resources/view/tailscale/
│   │       ├── interface.js       # Global Settings + Interface Info
│   │       ├── log.js             # Logs viewer
│   │       ├── setting.js         # Status pill + BITS theme
│   │       └── style.css          # local view styles
│   └── root/
│       ├── etc/hotplug.d/iface/40-tailscale
│       ├── etc/uci-defaults/40_luci-tailscale
│       └── usr/share/
│           ├── luci/menu.d/luci-app-tailscale.json
│           └── rpcd/acl.d/luci-app-tailscale.json
├── scripts/
│   └── prepare.js                 # sync version + build (used by semantic-release)
├── build.sh                       # SDK-less .ipk packer
├── control                        # ipk metadata
├── postinst                       # reload ACL/menu + tailscale update (best-effort)
├── package.json                   # semantic-release + plugins
├── .releaserc.json                # release plugins (git + github)
└── LICENSE
```

---

## 🚀 Quick Start

### Prerequisites

- An OpenWrt device (22.03+), with the `luci` feed installed
- Internet access for the `tailscale` binary

### 1. Download

Grab the `.ipk` from the [Releases](https://github.com/Banten-IT-Solutions/BITS-Tailscale/releases) page, then copy it to your device.

### 2. Install

```sh
opkg install luci-app-tailscale_<version>_all.ipk
```

`tailscale` (binary) is installed automatically via the package dependency. To force the latest official binary:

```sh
tailscale update
```

### 3. Use

Open LuCI (`Services → Tailscale`) and sign in with your Tailscale account.

---

## 🏗️ Build

Choose one method. **SDK-less** for a quick `.ipk`; **OpenWrt build system** for the official feed.

### Option A — SDK-less (bash + tar)

Best for fast development and CI. Requires only `bash` + `tar` &mdash; no toolchain.

```sh
./build.sh
# output: dist/luci-app-tailscale_<version>_all.ipk
```

> The OpenWrt `.ipk` format is an outer `tar.gz` containing `./debian-binary` + `./control.tar.gz` + `./data.tar.gz`.

### Option B — OpenWrt Build System

Copy the package folder to `feeds/luci/applications/`, then:

```sh
./scripts/feeds update -a
./scripts/feeds install luci-app-tailscale
make menuconfig   # LuCI -> Applications -> luci-app-tailscale
make package/luci-app-tailscale/compile
```

---

## 🚀 Release

Releases are automated with [semantic-release](https://semantic-release.gitbook.io) and [Conventional Commits](https://www.conventionalcommits.org). Write a conventional commit:

| Commit                           | Bump       |
| -------------------------------- | ---------- |
| `fix: ...`                       | patch      |
| `feat: ...`                      | minor      |
| `BREAKING CHANGE:` in body       | major      |

Push to `main` and the workflow builds the `.ipk` and publishes a GitHub Release with the asset attached.

---

## 📄 License

Distributed under the MIT License. See `LICENSE`.

---

<div align="center">
  <strong>BITS Tailscale</strong> Developed with ❤️ by <a href="https://bits.co.id"><strong>Banten IT Solutions</strong></a>
</div>