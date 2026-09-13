## [1.2.4](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.2.3...v1.2.4) (2026-09-13)


### Bug Fixes

* add replaces:tailscale to apk (avoid file conflict with tailscale) ([2146770](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/2146770a79d8929bd1fb31bc80770a779a5e8eeb))

## [1.2.3](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.2.2...v1.2.3) (2026-09-13)


### Bug Fixes

* standard apk filename (name-version-r0.apk) for apk feed ([6c6b907](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/6c6b907a6dc811d43515abb898d1a0f15d9519a6))

## [1.2.2](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.2.1...v1.2.2) (2026-09-13)


### Bug Fixes

* trailing newline di control + postinst (opkg parse warning) ([7a7f902](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/7a7f9022c82f67c3777ab041e72b4731402d4b14))

## [1.2.1](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.2.0...v1.2.1) (2026-09-13)


### Bug Fixes

* trailing newline di conffiles (hilangkan opkg parse warning) ([8e41a08](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/8e41a0817d1fb0367d9f87da4174085714a4262d))

# [1.2.0](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.1.1...v1.2.0) (2026-09-13)


### Bug Fixes

* clone apk-tools dari GitHub mirror (gitlab 418) ([7d4926d](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/7d4926d30560e53cb7b175e606d3600e894811e7))


### Features

* build .apk tanpa SDK via apk-tools v3 ([216495c](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/216495ced5c8c22b04a5aaa4daa1a5febe95a8a1))

## [1.1.1](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.1.0...v1.1.1) (2026-09-13)


### Bug Fixes

* tailscale as runtime dep (remove + to avoid Go source build) ([9be5ae4](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/9be5ae47707af1af309c27acea71bef60564c143))

# [1.1.0](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.9...v1.1.0) (2026-09-13)


### Features

* publish signed ipk/apk packages ([5a3f4fd](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/5a3f4fd14ab8bc8fca31fcc7f16a20eecae152e7))

## [1.0.9](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.8...v1.0.9) (2026-09-12)


### Bug Fixes

* narrow apk attach glob ([ee3d911](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/ee3d911453539d4f7c8a20dfe5f6d2150ec969c7))

## [1.0.8](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.7...v1.0.8) (2026-09-12)


### Bug Fixes

* enable apk package build ([7044a4e](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/7044a4e71fa1d457ff0a6129cc014c2e4a08e4bb))

## [1.0.7](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.6...v1.0.7) (2026-09-10)


### Bug Fixes

* bump ci trigger test ([94b9de3](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/94b9de3d794dd1f0010c8bedd661752f2944e3d4))

## [1.0.6](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.5...v1.0.6) (2026-09-09)


### Bug Fixes

* reorder LuCI menu (tailscale below bot in Services) ([7a0db9d](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/7a0db9d61ac872b09bd8cbf110d4e9a1d145b82b))

## [1.0.5](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.4...v1.0.5) (2026-09-09)


### Bug Fixes

* load style.css via inline <link> (menu.d 'css' field dropped by LuCI 24.10 dispatcher) ([b7c586e](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/b7c586eecf4c063aae9537c1bcfb5fd6724fc782))

## [1.0.4](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.3...v1.0.4) (2026-09-08)


### Bug Fixes

* ship patched helper + bits-full so install is drop-in (no reapply) ([b9e21bd](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/b9e21bd488c6dca013b053dd08d31e6ade63e66d))

## [1.0.3](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.2...v1.0.3) (2026-09-08)


### Bug Fixes

* ship conffiles file so opkg preserves /etc/config/tailscale ([23c85a8](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/23c85a8931d4ae7c7977fca9ca2f4a03d49b7e99))

## [1.0.2](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.1...v1.0.2) (2026-09-08)


### Bug Fixes

* ship init + config so replacing package keeps tailscaled alive ([ee3bb99](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/ee3bb9963fbe06ca5b062623de8fd8d2aa387031))

## [1.0.1](https://github.com/Banten-IT-Solutions/BITS-Tailscale/compare/v1.0.0...v1.0.1) (2026-09-08)


### Bug Fixes

* harden deps, logread path, XSS escape, hotplug guard ([bb88ea9](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/bb88ea937a3961f3b985118968a87c8f0a87fd71))

# 1.0.0 (2026-09-08)


### Features

* Tailscale LuCI app ([67ed2f9](https://github.com/Banten-IT-Solutions/BITS-Tailscale/commit/67ed2f9a4e8dc5b52b8fa000ea428c29140d9d78))
