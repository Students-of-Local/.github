# Contributing

A repo's own `AGENTS.md` wins over this page. These rules hold everywhere else.

- **Least maintenance wins.** Every line is ours to keep. Reuse what exists before writing code, and never copy another
  project's code in.
- **One change per pull request**, rebased on main, under about 400 changed lines. Never stack it on unmerged work.
- **A new feature, dependency or direction starts as an issue.** Write code once a maintainer agrees.
- **A product never depends on another product or a private service.** Everyone can run their own tunnel, Tailscale or VPN.
- **Check it end to end.** Build and run the real thing, and say what you ran. A check must be able to fail.
- **Swallow no errors.**
- **Describe only the change.** Leave out private paths, people and internal process.
