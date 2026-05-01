---
title: "Yog-Sothoth: How a Simple Question Changed the Nature of the Product"
date: 2026-05-01
lastmod: 2026-05-01
description: "Two weeks into building Yog-Sothoth, on a Sunday evening, I asked myself a simple question: does this already exist? Twenty-four hours later, the project's architecture had changed nature."
summary: "Two weeks into building Yog-Sothoth, on a Sunday evening, I asked myself a simple question: does this already exist? Twenty-four hours later, the project's architecture had changed nature."
categories: ["Yog-Sothoth"]
tags: ["Solana", "DeFi", "Meteora", "Rust"]
author: "Jean-Vivien Sicot"
draft: false
layout: blog
featured_image: ../assets/images/yog_sothoth_project_saas_en.png
---

### The starting point

Yog-Sothoth is a real-time liquidity analysis engine for Meteora pools, a decentralized exchange protocol on Solana. The tool ingests the on-chain transaction stream, reconstructs pool state, computes financial metrics, and will eventually expose alerts and visualizations through a web dashboard. It's not a block explorer like Solscan: it's an analysis and signal tool, somewhere between Dune Analytics and Nansen, focused on Meteora liquidity.

By the time I asked the question, I had two weeks of code behind me: the ingestion pipeline was working, DAMM v2 swap decoding was in place, PostgreSQL persistence too. What I had never done, however, was seriously check whether other tools already occupied this space.

### The review

I started with what I should have done at the outset: typing "Meteora analytics", "Meteora LP tracker", "Solana DEX flow analyzer" and reading what came back. Within an hour, I had a reasonable map of the landscape.

The first group is dense. UltraLP, TrackLP, MetLab, Tokleo, MetEngine, Cleopetra, Liquid Nova, Starseed. All built around the same proposition: _my positions, my P&L, my copy trading_. The user shows up with a wallet, the tool tracks what that wallet does in pools. The pool is the unit of subscription, the position is the unit of analysis.

The second group is more disparate. Bitquery offers Solana flows specific to DEXes, with explicit Meteora support and several delivery channels (WebSocket, Kafka, gRPC). It's powerful, but their product remains a structured data service: you subscribe to pairs, wallets, aggregated trades. The user is still the one defining what to observe. Shyft, on the other hand, sells Yellowstone gRPC streaming with DAMM v2 examples in Rust — technically very close to what I'm building, but positioned as an infrastructure provider. They sell the pipe, not what flows through it. Alongside these two, Blockworks Research exposes aggregated dashboards on Meteora (fees by pool, volumes), but on consolidated historical data for research use, not on the live flow.

What I'm looking for in this list is a tool that observes Meteora as a whole. One that doesn't ask the user to designate which pools to watch. One that doesn't reason in terms of individual positions but in terms of protocol flow — which pools concentrate activity, where liquidity moves, what patterns emerge at the scale of the entire protocol.

I don't find it. The LP tools are user-centric. The infrastructure providers are transport-centric. Nobody, in this list, positions themselves as an analytical observer of the protocol.

That's enough to convince me there's a space. Not a huge market, maybe not a market at all — but an angle that isn't taken.

### The pivot

Yog-Sothoth is not an LP tool. It's a flow observer that watches Meteora as a whole.

This sentence sounds harmless. It changes everything.

In the previous version, the base unit was the pool. The user declared which pools to follow, the system subscribed to each one, and all the analysis was built pool by pool. The pool was the entry key of the domain — the thing you subscribe to, index, store.

In the new version, the base unit is the protocol. You subscribe to Meteora as a whole. Pools become data emitted by the flow: they're discovered as transactions arrive, recorded along the way, never declared in advance. Analysis happens at the protocol level, and individual pools are just one dimension among others for slicing that flow.

The name takes on its meaning at that point. Yog-Sothoth, in Lovecraft's cosmogony, is the entity that sees everything simultaneously — past, present, future, all planes of existence at once. If the tool bears that name, it has to see everything happening on Meteora, not a selection. The pivot makes the project consistent with its own name.

And it places it in a space that the competitive review showed to be sparsely occupied.

### What this changes in the code

I had two weeks of code behind me, written with the pool as the key everywhere. The conceptual translation into code wasn't a detail — it touched the spine of the domain. Four changes capture the essentials.

**The pipeline's entry point.** `RpcListener` used to store a set of watched pools and open one WebSocket subscription per pool. It now stores a `HashSet<Protocol>` and opens one subscription per Meteora program. Concretely, the system shifts from N subscriptions (one per configured pool) to a handful of stable subscriptions (one per protocol variant). The system no longer asks the user what to watch: it watches Meteora.

**The data flowing between ingestion and indexing.** The typed channel connecting `RpcListener` to `IndexerService` used to carry `(WatchedPool, Signature)` — the pool was needed to know what to decode. It now carries `(Protocol, Signature)`. It's a single line of code, and it's the boundary between the two versions of the project: before, the pool identifier preceded the transaction; now, the transaction reveals it.

**Parsers that discover pools instead of receiving them.** Previously, parsers were instantiated with a `pool_address` argument — they were told in advance which pool they would decode. Now, they're instantiated without any address, and a helper `extract_pool_address` reads position 1 in the accounts of the outer DAMM v2 instruction to derive it from the transaction itself. It's a complete reversal of the flow: the pool is no longer an input to the parser, it's an output.

**A new domain model, `Pool`, as a discovery registry.** Where there was `WatchedPool` (declarative, created by the user), there's now `Pool` (descriptive, upserted on every incoming event). It's the database trace of the fact that nothing is configured anymore: we record what passes through.

The rest of the refactor follows mechanically from these four points. SQL migration redone from scratch without foreign keys to align the schema with the new domain. `reserve_a/b` renamed to `reserve_in/out` in `SwapEvent` because the swap direction now matters more than the stable convention of the old model. Removal of `WatchedPool`, `WatchedPoolService`, `PgWatchedPoolRepository` — all the machinery of the old world, now dead. The full diff is on the repo for anyone who wants to look.

### Mainnet test, that same evening

The refactor took a day. By the end, what remained was finding out whether the pipeline held up under real data. WebSocket connection to `api.mainnet-beta.solana.com`, subscription to the DAMM v2 program (`cpamdpZCGKUy5JxQXB4dcpGPiikHawvSWAd6mEn1sGG`), execution. Signatures arriving in real time.

First observed behavior: no swaps decoded. The DAMM v2 instruction detector consistently returns `false`. Diagnosis: `program_id_str` was passing the string `"meteora_damm_v2"` instead of the actual on-chain identifier — a leftover from the pool-centric model where the label was sufficient. One-line fix, the detector starts working again.

Second behavior: the detector now recognizes DAMM v2 transactions, but extracting the associated transfers fails every time. `extract_swap_transfers` was looking for the DAMM v2 instruction _inside_ the inner instructions, whereas in the new protocol-centric model it's an outer instruction that needs to be identified as such, with transfers then read from its inner group. Fixed by tracking the outer's index instead of doing blind matching. Extraction works.

After these two fixes, DAMM v2 swaps are decoded live against mainnet. Amounts come out correct, mints come out correct, pools appear in the discovery table as transactions arrive — without any of them having been declared in advance. The pipeline holds end to end.

Not everything is resolved. The public RPC is heavily throttled on `getTransaction`: acceptable for validating the architecture, untenable for continuous use — switching to Yellowstone gRPC (Shyft, Helius, Triton) will be necessary before claiming production readiness. Liquidity events, for their part, don't persist correctly to the database yet; swap decoding works, liquidity event decoding still needs work. And the pool-centric machinery isn't entirely removed — there are still zombie structs to clean up.

But the essential is validated. The pivot didn't stay a sketch on paper: it runs against mainnet on the same evening.

### What this day shifted

The lesson I take from this day isn't "check your competitors before coding". If I had done it at day zero, I would have had nothing concrete to compare against — no domain in mind, no sketched architecture, no intuition of what would be easy or hard to build. The review would have stayed abstract.

What this day shifted is my understanding of _when_ the question becomes useful. Checking that what you're building has an angle isn't a business plan step to tick off before writing the first line. It's an architecture step: it gets asked at the moment when you have enough code to understand what you're doing, and not yet enough for pivoting to cost too much. Two weeks, for this project, was about the right moment. Three months would have been too late.

The raw cost of the pivot is easy to count: a day of refactoring, two bugs caught during the run, some zombie code left to clean up. The cost of having continued without doing it is harder to quantify but more important. I would have shipped a product that already existed under eight other names, better funded and better distributed. Yog-Sothoth would have been a portfolio exercise, not an attempt at a product.

The question I leave open, and which has no clean answer, is one of frequency. How often should you reopen this question on an ongoing project? Every month? At every phase change? When you sense something doesn't fit, without knowing what? I don't have the answer. But I now know that asking it on a Sunday evening, almost out of boredom, can change the nature of a project in twenty-four hours.