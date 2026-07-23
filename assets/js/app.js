// Alpine.js vendoré localement (assets/js/vendor/alpine.esm.js, v3.15.12).
// Import relatif volontaire : le build Hugo/esbuild n'a pas besoin de
// node_modules, ce qui permet de builder sur Clever Cloud (hugo seul).
import Alpine from './vendor/alpine.esm.js'

window.Alpine = Alpine
Alpine.start()
