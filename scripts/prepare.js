// prepare.js — dipanggil semantic-release pada fase "prepare".
// Menyelaraskan versi package.json + package-lock.json + Makefile.
const fs = require('fs');
const { execSync } = require('child_process');

const version = process.argv[2];

if (!version) {
  console.error('usage: node scripts/prepare.js <version>');
  process.exit(1);
}

// 1) bump package.json + package-lock.json (npm version sinkron keduanya)
execSync(`npm version --no-git-tag-version ${version}`, { stdio: 'inherit' });

// 2) bump Makefile (OpenWrt build system PKG_VERSION)
let makefile = fs.readFileSync('luci-app-bitstailscale/Makefile', 'utf8');
makefile = makefile.replace(/^PKG_VERSION:=.*$/m, `PKG_VERSION:=${version}`);
fs.writeFileSync('luci-app-bitstailscale/Makefile', makefile);

console.log(`prepared version ${version}`);