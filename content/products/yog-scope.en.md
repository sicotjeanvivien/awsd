+++
title = "Yog-Scope"
description = "Real-time liquidity analytics for Meteora pools on Solana."
weight = 1

[extra]
summary = "Real-time liquidity analytics for Meteora pools on Solana: on-chain indexing, history and alerts, in a free public dashboard."
status = "production"
status_label = "In production"
since = "Oct. 2026"
url = "https://yog-scope.xyz"
source = "https://github.com/sicotjeanvivien/yog-sothoth"
platform = "Web"
kicker = ["Rust", "Solana"]
stack = ["Rust", "Solana", "TimescaleDB"]
crates = ["yog-core", "yog-persistence", "yog-api"]
access = "Free · public source code"
flow = ["Solana RPC", "indexer", "API", "dashboard"]
flow_caption = "data flow"
blog_taxonomy = "categories"
blog_term = "Yog-Sothoth"
facts = [
    { label = "Ingestion", value = "Real time, WebSocket" },
    { label = "History", value = "Since 6 Oct. 2026" },
    { label = "Signals", value = "3 detectors" },
    { label = "Access", value = "Free · public source code" },
]
features_title = "What Yog-Scope does"
features = [
    { title = "Observe", text = "Tracks pools, liquidity changes and market activity on Meteora." },
    { title = "Reconstruct", text = "Hourly liquidity history: additions and withdrawals, hour by hour." },
    { title = "Analyse", text = "Anomaly detection: flow imbalances, price deviations, TVL drains." },
    { title = "Alert", text = "Real-time alerts on key events, ranked by severity." },
]
pipeline_title = "From chain to screen"
pipeline_note = "one indexer per protocol"
pipeline = [
    { step = "Listen", text = "Permanent WebSocket connection to a Solana RPC." },
    { step = "Decode", text = "Swaps, liquidity, fees, positions, locks." },
    { step = "Enrich", text = "Token metadata and USD prices." },
    { step = "Store", text = "Time-series database (TimescaleDB), queryable." },
    { step = "Serve", text = "Typed HTTP API and public dashboard, FR / EN." },
]
cta_title = "The dashboard is public and free."
cta_text = "No account needed."
+++
