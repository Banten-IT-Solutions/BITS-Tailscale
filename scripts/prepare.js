// prepare.js — dipanggil semantic-release pada fase "prepare".
// Menyelaraskan versi paket + control, lalu mem-build .ipk dengan versi baru.
const fs = require('fs');
const { execSync } = require('child_process');

const version = process.argv[2];

if (!version) {
  console.error('usage: node scripts/prepare.js <version>');
  process.exit(1);
}

// 1) bump package.json
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.version = version;
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');

// 2) bump control (opkg)
let control = fs.readFileSync('control', 'utf8');
control = control.replace(/^Version: .*$/m, `Version: ${version}`);
fs.writeFileSync('control', control);

// 3) build ipk (build.sh membaca Version dari control)
execSync('bash build.sh', { stdio: 'inherit' });

console.log(`prepared version ${version}`);