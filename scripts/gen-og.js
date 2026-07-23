#!/usr/bin/env node
/**
 * Génère les images de partage Open Graph (1200x630) à la charte AWSD.
 * Sortie : static/images/og/og-default.png (FR) et og-default-en.png (EN).
 *
 * Usage : npm run og   (ou : node scripts/gen-og.js)
 * Dépendance : @resvg/resvg-js (devDependency). Utilise la police DejaVu Sans
 * du système ; ajuste `fontDirs` ci-dessous si elle est ailleurs.
 */
const fs = require('fs');
const path = require('path');
const { Resvg } = require('@resvg/resvg-js');

const ROOT = path.resolve(__dirname, '..');
const OUT_DIR = path.join(ROOT, 'static/images/og');
const LOGO = path.join(ROOT, 'static/images/digital_logo.png');
const FONT_DIRS = ['/usr/share/fonts/truetype/dejavu'];

const logoB64 = fs.readFileSync(LOGO).toString('base64');
const logoH = 76, logoW = Math.round(612 * (logoH / 408)); // logo 612x408
const M = 96; // marge gauche

const variants = {
  'og-default.png': [
    "Conception, audit et développement d'applications",
    'web performantes, sécurisées et durables.',
  ],
  'og-default-en.png': [
    'Design, audit and development of high-performance,',
    'secure and sustainable web applications.',
  ],
};

const buildSvg = (l1, l2) => `<?xml version="1.0" encoding="UTF-8"?>
<svg width="1200" height="630" viewBox="0 0 1200 630" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#0a1929"/>
      <stop offset="1" stop-color="#102a43"/>
    </linearGradient>
  </defs>

  <rect width="1200" height="630" fill="url(#bg)"/>

  <!-- motif code décoratif, discret, à droite -->
  <text x="1140" y="360" font-family="DejaVu Sans" font-weight="bold" font-size="360"
        fill="#486581" fill-opacity="0.10" text-anchor="end">&lt;/&gt;</text>

  <!-- filet vertical d'accent -->
  <rect x="0" y="0" width="12" height="630" fill="#486581"/>

  <!-- logo -->
  <image x="${M}" y="86" width="${logoW}" height="${logoH}"
         href="data:image/png;base64,${logoB64}"/>

  <!-- wordmark -->
  <text x="${M}" y="300" font-family="DejaVu Sans" font-weight="bold" font-size="132"
        fill="#ffffff" letter-spacing="6">AWSD</text>

  <!-- barre d'accent -->
  <rect x="${M + 4}" y="330" width="118" height="7" rx="3" fill="#829ab1"/>

  <!-- moto -->
  <text x="${M}" y="410" font-family="DejaVu Sans" font-weight="bold" font-size="40"
        fill="#bcccdc">Artisan Web Software Development</text>

  <!-- description sur 2 lignes -->
  <text x="${M}" y="474" font-family="DejaVu Sans" font-size="29" fill="#9fb3c8">${l1}</text>
  <text x="${M}" y="512" font-family="DejaVu Sans" font-size="29" fill="#9fb3c8">${l2}</text>

  <!-- domaine -->
  <text x="${M}" y="575" font-family="DejaVu Sans" font-weight="bold" font-size="30"
        fill="#627d98" letter-spacing="1">awsd.fr</text>
</svg>`;

fs.mkdirSync(OUT_DIR, { recursive: true });
for (const [name, [l1, l2]] of Object.entries(variants)) {
  const resvg = new Resvg(buildSvg(l1, l2), {
    fitTo: { mode: 'width', value: 1200 },
    font: { fontDirs: FONT_DIRS, defaultFontFamily: 'DejaVu Sans', loadSystemFonts: false },
  });
  const png = resvg.render().asPng();
  fs.writeFileSync(path.join(OUT_DIR, name), png);
  console.log('écrite:', name, png.length, 'octets (1200x630)');
}
