# Security Policy

We take the security of Serverpod seriously. Thank you for helping keep Serverpod and the apps built with it safe.

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.**

Report them privately through one of these channels:

- **Email:** [security@serverpod.dev](mailto:security@serverpod.dev)
- **GitHub:** [Open a private security advisory](https://github.com/serverpod/serverpod/security/advisories/new)

Please include as much of the following as you can:

- The affected package(s) and version(s)
- A description of the issue and its potential impact
- Step-by-step instructions to reproduce it, or a proof of concept
- Any known workarounds or suggested fixes
- Whether you'd like to be credited, and under what name

You can write to us in English.

## What to expect

| Step | Target time |
| --- | --- |
| Acknowledgement of your report | Within 3 business days |
| Initial assessment and severity rating | Within 10 business days |
| Status updates | At least every 14 days until resolved |
| Fix released for critical/high issues | As soon as possible, normally within 90 days |

We'll keep you informed as we work on a fix and agree on a disclosure date with you. Once a fix is released, we'll publish a GitHub Security Advisory (and request a CVE where appropriate), crediting you unless you prefer to stay anonymous.

## Supported versions

Security fixes are released for the latest major version of Serverpod. Critical fixes may be backported to the previous major version at our discretion.

| Version | Supported |
| --- | --- |
| Latest major (current) | ✅ |
| Previous major | ⚠️ Critical fixes only |
| Older | ❌ |

## Scope

In scope:

- The Serverpod framework and all packages published from this repository (e.g. `serverpod`, `serverpod_client`, `serverpod_auth_*`, `serverpod_cli`)
- Generated code produced by the Serverpod CLI
- Official project templates

Out of scope:

- Vulnerabilities in applications built with Serverpod that result from the application's own code or configuration
- Vulnerabilities in third-party dependencies that are already publicly known (please report those upstream)
- Denial-of-service attacks, spam, or social engineering
- Findings from automated scanners without a demonstrated impact

Unsure whether something is in scope? Report it anyway, and we'll take a look.

## Safe harbor

We won't pursue legal action against anyone who, in good faith:

- Reports a vulnerability privately through the channels above
- Avoids privacy violations, data destruction, and service disruption
- Only tests against their own installations, not other people's systems or data
- Gives us reasonable time to fix the issue before disclosing it publicly

## Bug bounty

We don't currently run a paid bug bounty program, but we're grateful for every report and are happy to credit researchers publicly.
