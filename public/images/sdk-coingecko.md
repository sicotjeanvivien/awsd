---
title: "SDK CoinGecko (TypeScript, Node.js)"
date: 2025-09-10
summary: "SDK en TypeScript pour interagir avec l’API CoinGecko : endpoints courants, typage fort et distribution npm."
tags: ["TypeScript", "Node.js", "SDK", "Crypto", "API"]
cover:
  image: "images/projets/sdk-coingecko-cover.png"
  alt: "SDK CoinGecko pour Node.js"
status: "Terminé et publié"
links:
  - title: "GitHub"
    url: "https://github.com/sicotjeanvivien/sdk_coingecko"
  - title: "npm"
    url: "https://www.npmjs.com/package/@awsd/sdk_coingecko"
---

## Contexte
Un SDK léger et typé pour interagir avec l’API publique CoinGecko, conçu pour Node.js avec TypeScript.  

## Stack & techniques
- **Langage** : TypeScript (>=5.x)  
- **Runtime** : Node.js (ESM)  
- **Tests** : Jest  
- **Distribution** : npm  

## Points clés
- Endpoints organisés par domaine (simple, coins, markets…).  
- Typage strict → meilleure DX (autocomplétion, erreurs réduites).  
- Gestion claire des erreurs API.  

## Exemple
```ts
import { CoinGeckoClient } from "@awsd/sdk_coingecko";

const client = new CoinGeckoClient();
const price = await client.simple.price({ ids: ["bitcoin"], vs_currencies: ["usd"] });
console.log(price);
````

## Liens

* [GitHub](https://github.com/sicotjeanvivien/sdk_coingecko)
* [npm](https://www.npmjs.com/package/@awsd/sdk_coingecko)

````
