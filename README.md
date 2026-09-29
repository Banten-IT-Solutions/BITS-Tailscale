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
| **Binary Auto-install**   | Package `Depends: tailscale`, so `opkg` / `apk` installs the dependency when available from a feed.              |
| **Best-effort Update**    | `postinst` attempts `tailscale update` in the background; failure is non-fatal.                                  |
| **Automated Release**     | semantic-release builds `.ipk` + `.apk` and publishes a GitHub Release when commits qualify for release.         |

## 🛠️ Tech Stack

| Layer        | Technology                                                                        |
| ------------ | --------------------------------------------------------------------------------- |
| **Runtime**  | OpenWrt (LuCI)                                                                    |
| **Backend**  | `init.d` service (procd), `tailscale_helper`, `rpcd` ACL, `uci-defaults`, `hotplug.d` |
| **Language** | JavaScript (LuCI AMD views loaded via `require`)                                  |
| **Theme**    | Portable `style.css` (status pill + dark mode)                                    |
| **Build**    | `bash` + `tar` (ipk) + `apk-tools v3` (apk) — no SDK                              |
| **Release**  | semantic-release + GitHub Actions                                                 |

---

## 📁 Project Structure

```text
BITS-Tailscale/
├── .github/
│   ├── dependabot.yml             # dependency updates (npm + actions)
│   └── workflows/
│       ├── lint.yml               # shellcheck + actionlint
│       └── release.yml            # semantic-release + build .ipk/.apk + attach assets
├── luci-app-bitstailscale/
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
│   └── prepare.js                 # sync version + build .ipk/.apk (semantic-release)
├── build.sh                       # SDK-less .ipk + .apk packer
├── control                        # ipk metadata
├── postinst                       # reload ACL/menu + best-effort tailscale update
├── conffiles                      # preserve /etc/config/tailscale on upgrade
├── package.json                   # semantic-release + plugins
├── package-lock.json              # npm lockfile (npm ci)
├── .releaserc.json                # release plugins (git + github)
└── LICENSE
```

---

## 🚀 Quick Start

### Prerequisites

- OpenWrt device with the `luci` feed installed. Target support: OpenWrt 22.03+ for `.ipk`; OpenWrt 25.12+ for `.apk`. The repository has no compatibility test matrix; compatibility reports and contributions are welcome.
- Internet access and an available `tailscale` package from a feed. Package dependencies: `libc`, `luci-base`, `rpcd`, `tailscale`.

### 1. Download

Download package from [Releases](https://github.com/Banten-IT-Solutions/BITS-Tailscale/releases), then copy it to your device:

- `.ipk` for `opkg`: `luci-app-bitstailscale_<version>_all.ipk`
- `.apk` for `apk-tools v3`: `luci-app-bitstailscale-<version>-r0.apk`

### 2. Install

```sh
# Install the .ipk package
opkg install ./luci-app-bitstailscale_<version>_all.ipk

# Install the apk-tools v3 package
apk add ./luci-app-bitstailscale-<version>-r0.apk
```

After installation, `postinst` restarts `rpcd`, clears LuCI index/module caches, and runs `tailscale update` in the background on a best-effort, non-fatal basis. The package depends on a `tailscale` binary available from a feed; the update attempt does not guarantee the latest official version.

### 3. Use

Open LuCI (`Services → BITS Tailscale`) and sign in with your Tailscale account.

---

## ⚙️ UCI Configuration

Configuration file: `/etc/config/tailscale`.

| Option | Default | Function |
|---|---|---|
| `enabled` | `0` | Enables the service. Must be `1`; otherwise the service does not run. |
| `port` | `41641` | UDP port for `tailscaled`. |
| `config_path` | `/etc/tailscale` | `tailscaled` working/state directory, containing `tailscaled.state`. |
| `fw_mode` | `nftables` | Firewall mode (`nftables` or `iptables`), passed through `TS_DEBUG_FIREWALL_MODE`. |
| `log_stdout` / `log_stderr` | `1` / `1` | Enable procd stdout/stderr logging. |
| `accept_routes` | off | Accept subnet routes advertised by other nodes. |
| `hostname` | (empty) | Device name; empty uses the device hostname. |
| `accept_dns` | on | Accept DNS settings from the Tailscale console; also enables MagicDNS/dnsmasq configuration. |
| `advertise_exit_node` | off | Advertise this device as an exit node. |
| `exit_node` | (empty) | Use a specific exit node. |
| `advertise_routes` | (empty) | Advertise local subnets, for example `10.0.0.0/24`. |
| `disable_snat_subnet_routes` | off | Disable SNAT for site-to-site Layer 3 routing. |
| `subnet_routes` | (empty) | Select subnet routes advertised by other nodes. |
| `access` | `ts_ac_lan ts_ac_wan lan_ac_ts` | Firewall forwarding rules between Tailscale and LAN/WAN. Options: `ts_ac_lan`, `ts_ac_wan`, `lan_ac_ts`, `wan_ac_ts`. |
| `flags` | (empty) | Additional arguments for `tailscale up`. Each token must use `--option[=value]`; other tokens are ignored and logged. Glob expansion is disabled. `--authkey`, `--auth-key`, `--state`, and `--socket` are rejected. |
| `login_server` | (empty) | Custom control server. |
| `authkey` | (empty) | Optional authentication key. |

> Only `enabled`, `port`, `config_path`, `fw_mode`, `log_stdout`, and `log_stderr` ship in `/etc/config/tailscale`. The remaining options are written when you save the LuCI form, so the defaults above are the **form** defaults. Enabling the service with plain `uci` leaves them unset; in that case `ACCEPT_DNS` never equals `1`, so `tailscale_helper` skips the MagicDNS/dnsmasq wiring.

---

## 🔐 LuCI ACL / Permissions

The `rpcd/acl.d` ACL grants:

- Read and write access to UCI `tailscale`.
- Command execution: `/sbin/ip -s -j ad`, `/sbin/logread -e tailscale`, `/usr/libexec/logread-ubox -e tailscale`, `/usr/sbin/tailscale status --json`, `/usr/sbin/tailscale login`, and `/usr/sbin/tailscale logout`.
- Ubus access to `service.list`.

Any LuCI user granted this ACL can write Tailscale configuration, including `authkey` and `flags`.

---

## 🏗️ Build

`build.sh` creates `.ipk` and `.apk` packages without the OpenWrt SDK. It requires Bash, `tar` (with `gzip`), `awk`, and `tr`. To build `.apk`, use apk-tools v3 with the `mkpkg` applet; set `APK_BIN` if the binary is not in `PATH`. Node.js 24 and npm are not required by `build.sh`; they are used only by CI release automation (`semantic-release`).

In CI, an `.apk` artifact is required: with `CI=true`, the build fails if the `apk` binary is unavailable. Locally, the `.apk` build may be skipped with a warning.

```sh
./build.sh
# output: dist/luci-app-bitstailscale_<version>_all.ipk
#         dist/luci-app-bitstailscale-<version>-r0.apk
```

> `.ipk` is an outer `tar.gz` archive containing `debian-binary`, `control.tar.gz`, and `data.tar.gz`. `.apk` is an apk-tools v3 package created with `apk mkpkg`. The `.apk` build uses `replaces:tailscale`; the `.ipk` uses the bundled `control` metadata, which has no `Replaces` or `Conflicts` field.

---

## 🚀 Release

Releases use [semantic-release](https://semantic-release.gitbook.io) and [Conventional Commits](https://www.conventionalcommits.org):

| Commit | Bump |
|---|---|
| `fix: ...` | patch |
| `feat: ...` | minor |
| `BREAKING CHANGE:` footer or `feat!:` / `fix(scope)!:` | major |

Pushes to `main` create a release only when commits qualify for a release; a push without release-worthy commits does not create one. The workflow builds `.ipk` and `.apk`, then publishes assets to GitHub Releases.

---

## 🩹 Troubleshooting

| Symptom | Check |
|---|---|
| Menu opens but nothing happens | Service is disabled: `enabled` defaults to `0`. Set `uci set tailscale.settings.enabled=1 && uci commit tailscale`, then start the service. |
| Status stays *Disconnected* | `tailscale status` and `/etc/init.d/tailscale status`. If `tailscaled` is not running, inspect procd logs. |
| No logs | `logread -e tailscale` (or `/usr/libexec/logread-ubox -e tailscale` on newer builds). Helper errors are logged as `tailscale_helper`. |
| Login link missing | `tailscale status --json` must expose `AuthURL`. The view only renders an `https://` login link; otherwise it shows plain text. |
| Hotplug/start issues | `/tmp/tailscale.log` (rewritten on each qualifying interface event). |
| After install the menu is missing | `postinst` restarts `rpcd` and clears the LuCI index cache. If the menu is still missing, log out and back in so the ACL is re-evaluated. |

---

## 📄 License

Distributed under the MIT License. See [`LICENSE`](LICENSE).

---

<div align="center">
  <strong>BITS Tailscale</strong> Developed with ❤️ by <a href="https://bits.co.id"><strong>Banten IT Solutions</strong></a>
</div>
