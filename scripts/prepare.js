// prepare.js — dipanggil semantic-release pada fase "prepare".
// Menyelaraskan versi (package.json + lockfile + control + Makefile), lalu build .ipk.
const fs = require('fs');
const { execSync } = require('child_process');

const version = process.argv[2];

if (!version) {
  console.error('usage: node scripts/prepare.js <version>');
  process.exit(1);
}

// 1) bump package.json + package-lock.json (npm version sinkron keduanya)
execSync(`npm version --no-git-tag-version ${version}`, { stdio: 'inherit' });

// 2) bump control (ipk ~ opkg)
let control = fs.readFileSync('control', 'utf8');
control = control.replace(/^Version: .*$/m, `Version: ${version}`);
fs.writeFileSync('control', control);

// 3) bump Makefile (OpenWrt build system PKG_VERSION)
let makefile = fs.readFileSync('luci-app-bitstailscale/Makefile', 'utf8');
makefile = makefile.replace(/^PKG_VERSION:=.*$/m, `PKG_VERSION:=${version}`);
fs.writeFileSync('luci-app-bitstailscale/Makefile', makefile);

// 4) build .ipk (build.sh membaca Version dari control)
execSync('bash build.sh', { stdio: 'inherit' });

console.log(`prepared version ${version}`);