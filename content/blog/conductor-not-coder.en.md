---
title: "Conductor, not Coder"
date: 2026-06-07
lastmod: 2026-06-07
description: "Two months on Yog-Sothoth, hundreds of commits, almost no line of code written by my own hand. And I still call it my project. Here's why."
summary: "Two months on Yog-Sothoth, hundreds of commits, almost no line of code written by my own hand. And I still call it my project. Here's why."
categories: ["Yog-Sothoth"]
tags: ["Rust", "Solana", "Meteora", "AI"]
author: "Jean-Vivien Sicot"
draft: false
layout: blog
featured_image: ../assets/images/conductor_not_coder.png
---

I've never produced as much as I have since I started using AI. And yet, some days, after six commits and seven hours of work, I feel like I've done nothing.

For two months, I've been building Yog-Sothoth alone — an analytics and observability tool for the Meteora DeFi protocol on Solana. Architecture, Rust backend, Next.js frontend, database, CI/CD, Docker, UX, content, documentation — that's me on all of it. A project of this complexity normally requires a team: a backend developer, a frontend developer, a DevOps engineer, a product manager, occasionally a designer or a data analyst. The cost can climb to €10,000 a month.

And yet I'm doing it alone. Does AI replace a team? After two months of intensive development, my answer is no. But it fundamentally changes the size of the team you need, and the role of each person in it.

### How it actually goes

At the start of the project, Claude proposes a three-piece architecture: a Rust daemon for the indexer, Next.js for the frontend, Node.js for the API. It's coherent, I approve it, I move on.

Then comes the day I start the API. I write code, and I realize I'm about to rewrite in Node everything that already exists in `yog-core`, my shared Rust crate: schemas, SQL queries, repositories, contracts. It's all there, cleanly separated between the domain and the persistence layer in a standalone `yog-persistence` crate. And I'm about to maintain two implementations of the same domain.

I stop. I reopen the discussion with Claude. Its first answer: building the API in Rust will take much more work. That's wrong — it doesn't see that the domain factoring in `yog-core` makes the operation trivial. I decide: it will be a `yog-api` crate in Rust. Two days later, the API is in place.

A week later, same story. The API works but it's hand-rolled. I restart the conversation, I identify the problem, Claude proposes, I choose: switch to axum. The implementation takes a day. Acceptable, because I'd spent time up front cutting the project along DDD and SRP lines, and any one piece can be swapped without touching the rest.

### What AI does better than I do

I barely write any code anymore. But no line is added without my approval. Claude writes and proposes; I approve, reject, redirect.

At pure coding, AI is better than I am. It produces higher-quality code, faster, without syntax errors. Repetitive tasks become a formality: Zod schemas, DTOs, unit tests. It codes, I verify.

Shipping a feature used to take time: reading documentation, searching StackOverflow or GitHub, then trial and error. The cycle is different now: I lay out the problem and the context, I have a technical discussion with Claude, we explore several paths and weigh complexity against relevance, the code gets generated once the context is solid, I verify, I integrate.

It's much less sexy than the vibe-coding fantasy. It's also much more effective.

### Then what am I for?

If Claude writes the code, what am I for?

Whatever the exact nature of what AI is doing, it doesn't carry the consequences of its proposals. It doesn't know which problem is important and which can wait. It doesn't know what actually adds value to the product. It proposes, I live with it.

A concrete example. At the start, Yog-Sothoth was pool-centric: the project was built around pools, like most DeFi observability tools. That's what the words "DeFi" and "observability" naturally evoke, and it's exactly what an AI proposes — a weighting of probabilities over related vocabulary.

An AI would never have made the decision to switch to protocol-centric. And yet that's the project's best decision, the one that gives it its whole point. Because this isn't a technical problem: it's a problem of market understanding and product positioning.

To the AI, option A and option B are two probability distributions. To me, they're choices I'm committed to — I'm the one who'll pay the cost of the wrong one. I'm the only one guaranteeing the project's long-term coherence. I'm the only one with the full picture: product, architecture, constraints, future evolutions.

And before anyone tells me "you're not giving it enough context": Yog-Sothoth is a complex project split into multiple subsystems. The context isn't complex in itself — what's complex is the different contexts and their interactions. No AI can hold that load yet.

### Is it still my product?

If all I do is direct, without producing anything myself, is Yog-Sothoth my product, or an assemblage of fragments written by others and recycled by the AI?

Flip the question: a developer who copies a snippet from StackOverflow and pastes it into their project — do they still own that project? Yes. Because the value of a project has never been in the syntax of the code. It's in the understanding of the domain, in the ability to translate a business need into a program.

The value of Yog-Sothoth isn't in the Rust syntax, the React components, or the SQL queries. It's in the choice of which data to observe, which metrics to compute, which architecture to set up, which tradeoffs to accept. Those are my choices, my responsibilities.

### Conclusion

The job is changing. I code less, I produce more, I'm cognitively tired. The satisfaction metric is no longer the number of lines shipped but the number of decisions made correctly. I'm no longer a coder — I'm a conductor, and it's far more demanding.

I don't know what the developer job will look like in five or ten years. What I am convinced of, though, is this: AI doesn't replace responsibility. Someone still has to set the direction, arbitrate the choices, understand why the product exists, and own the consequences.

AI hasn't turned me into a team of ten. It's let me concentrate my time on the decisions that matter, by delegating execution.

For now, the one who decides is still the developer.