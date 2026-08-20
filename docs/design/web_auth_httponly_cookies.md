# Design: Web Authentication with httpOnly Cookies

Moves Serverpod's web authentication off JavaScript-readable token storage and
onto httpOnly cookies (issue
https://github.com/serverpod/serverpod/issues/4045).

Scope: browser (Flutter/Dart web) clients. Native and desktop clients already
use OS-backed secure storage (Keychain / encrypted shared preferences) and keep
header authentication; they are unchanged.

## Motivation

`localStorage`, `sessionStorage` and IndexedDB are readable by any JavaScript
on the page. An XSS foothold can exfiltrate a token stored there and replay it
from anywhere for its lifetime.

httpOnly cookies cannot be read by JS. XSS can still ride the session while the
page is open, but cannot steal the credential for later replay. OWASP: "Do not
store session identifiers in local storage as the data is always accessible by
JavaScript. Cookies can mitigate this risk using the httpOnly flag." The common
SPA pattern is access token in memory, refresh token in an httpOnly cookie.

## Goals and non-goals

Goals: secure storage and transport for browser clients (both auth strategies);
opt-in (no forced break outside a major); cross-subdomain support.

Non-goals: native/mobile/desktop storage; a BFF / OAuth-confidential-client
rearchitecture; changes to the identity providers (email, OAuth, passkeys).

## Design

### Token placement

```
+----------------------+---------------------------------+---------------------------------+
| Strategy             | Access / session token          | Refresh token                   |
+======================+=================================+=================================+
| JWT                  | In memory (restored on load)    | HttpOnly Secure SameSite cookie |
| Opaque session (SAS) | HttpOnly Secure SameSite cookie | n/a (server-side session)       |
+----------------------+---------------------------------+---------------------------------+
```

"In memory" means not in `localStorage`, `sessionStorage`, or a non-httpOnly
cookie. On page load the SPA calls the refresh endpoint; the browser sends the
refresh cookie and the server returns a fresh access token in the body.
Credentials never appear in URLs (the former `?auth=` query fallback is a
documented Serverpod 4.0 breaking change).

### Opting in

Cookie auth is opt-in on both sides; otherwise the header path is unchanged.

- Server: an `authCookie` config section (name, refresh cookie name, domain,
  path, secure, sameSite). It requires a non-empty `allowedOrigins` list, which
  backs the Origin checks and credentialed CORS below.
- Client: `client.cookieAuth = true`, set immediately after construction. Only
  browser transports support it; enabling it elsewhere fails loudly.

```
authCookie:
  name: serverpod_auth   # default
  refreshName:           # defaults to <name>_refresh
  domain:                # host-only by default; set example.com to share
  path: /                # default
  secure: true           # default; set false only for http://localhost
  sameSite: lax          # lax (default) | strict | none (none requires secure)
allowedOrigins:
  - https://app.example.com
```

### Request protocol

- A cookie-mode client sends every request credentialed, with a marker header
  (`x-serverpod-auth-mode`): `cookie` on authenticated calls, or
  `cookie-transport` on unauthenticated calls (sign-in, refresh), which lets
  cookies travel and be set but never lets the main auth cookie authenticate
  the call.
- The server reads the auth cookie as an authentication fallback only when the
  marker is `cookie`, no Authorization header is present, and the request
  `Origin` (if any) is allow-listed. Ambient cookies never authenticate a
  request that did not opt in.
- The refresh cookie is read only by the JWT refresh endpoint, and its `Path`
  is scoped to that endpoint's route, so the browser attaches the refresh token
  only to refresh calls. Cookie-mode clients declare their browser-visible base
  path (`x-serverpod-base-path`) so the scoping stays correct behind a
  prefix-stripping reverse proxy; a cookie `Path` is not a security boundary,
  so the client-supplied value is safe to use after a format check, falling
  back to the configured cookie path.
- Cookie `Max-Age` derives from the token or refresh-token lifetime; a session
  cookie is used when there is none.

### Secrets and the response body

On a cookie-mode request, issued secrets are delivered as `Set-Cookie` and
masked from the serialized response body: SAS returns an empty `token`, JWT
returns the access token but no `refreshToken`. Masking applies at
serialization only — server-side code that issued the token can still read the
real values, e.g. to attach metadata to the new session. The client refuses to
persist secrets that unexpectedly arrive in the body (a misconfigured server
fails fast rather than silently downgrading to JS-readable storage).

### Sign-in policy

Token issuance applies one policy for every token type, on both web and native:

```
+------------------------+-----------------+---------------------------------------+
| Already signed in as A | Credentials for | Result                                |
+========================+=================+=======================================+
| no                     | B               | Normal sign-in; may set cookie        |
| yes                    | A               | Re-issue (cookie replace / new token) |
| yes                    | B               | Rejected; sign out first              |
+------------------------+-----------------+---------------------------------------+
```

The rejection is a typed, client-catchable error. Account linking (merging two
identities) is the intended future escape hatch for the last row. Minting a
token on behalf of another user (e.g. an admin flow) remains possible on the
server through direct token creation, which never sets cookies and returns the
secrets in the body for the caller to pass on.

### Sign-out

Sign-out revokes the session server-side and clears both auth cookies (the
refresh cookie with the same resolved path, which browsers require for
removal).

### Streaming

Browsers attach cookies to the WebSocket handshake automatically, so method
streams on a cookie-mode client authenticate from the handshake cookie — no
URL token and no in-band credential. The handshake `Origin` is validated
against `allowedOrigins`.

Streaming contract: a stream authenticates when it opens and keeps that
identity. When the signed-in identity changes (sign-in, sign-out, or user
switch), open method streams are closed gracefully — subscriptions receive
`onDone` without an error — in both cookie and header mode; new streams connect
with the current identity. Same-identity updates, such as a JWT token rotation,
keep streams running.

### CORS

Credentialed CORS cannot use the wildcard origin. With `authCookie` enabled the
server echoes the specific request `Origin` when allow-listed (plus
`Access-Control-Allow-Credentials: true` and `Vary: Origin`), and drops the
wildcard for a present-but-non-allow-listed browser `Origin`. Enabling cookie
auth therefore requires every cross-origin browser caller — including callers
of public endpoints — to be in `allowedOrigins`. The cookie-auth request
headers are always part of the allowed CORS request headers.

### Cross-subdomain

`Domain=example.com` lets the cookie reach `app.example.com`,
`api.example.com`, etc. `SameSite=Lax`/`Strict` treats sibling subdomains of
the same registrable domain as same-site, so this works without
`SameSite=None`. Exposed via `authCookie.domain` (host-only by default).

## Security considerations

Cookie auth reintroduces CSRF (header/bearer auth is immune since the browser
never auto-attaches it). The posture is defense in depth:

1. SameSite on the auth cookie. `Lax` (default) blocks cross-site POST;
   `Strict` breaks link-into-authed-page and OAuth redirect returns; `None`
   only for cross-site embedding (rejected without `Secure`). SameSite alone
   does not cover a same-registrable-domain sibling subdomain, which the next
   two layers do.
2. Origin validation against `allowedOrigins`, on both HTTP cookie reads and
   the WebSocket handshake, independent of the browser's own CORS enforcement.
   A present-but-non-allow-listed `Origin` is rejected; a missing `Origin`
   (native / server-to-server) is allowed.
3. Marker-header requirement: the auth cookie only authenticates a request
   carrying the `cookie` marker. A cross-site form or simple request cannot set
   a custom header without a CORS preflight, which fails for non-allow-listed
   origins. (WebSocket handshakes cannot send custom headers; the WS path
   relies on layer 2.)
4. Optional double-submit CSRF token, held in reserve for `SameSite=None`
   (future work).

The cookie read fails closed on an ambiguous `Cookie` header: when more than
one cookie carries the configured name (e.g. a sibling subdomain plants a
`Domain`-scoped duplicate), none is trusted.

httpOnly stops token theft but not session riding (an XSS payload can issue
authenticated requests while the page is open); mitigate with CSP and
dependency hygiene. A BFF (no tokens in the browser) is the option for stricter
requirements.

## Future work

- Optional double-submit CSRF token for `SameSite=None`.
- BFF guidance for deployments with stricter requirements.
- Account linking, which will extend the sign-in policy with a merge flow.

## Sources

- OWASP, JSON Web Token Cheat Sheet:
  https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html
- OWASP, WebSocket Security Cheat Sheet:
  https://cheatsheetseries.owasp.org/cheatsheets/WebSocket_Security_Cheat_Sheet.html
- Curity, OAuth for SPAs / BFF:
  https://curity.io/resources/learn/spa-best-practices/
- CORS, SameSite and CSRF (Liran Tal):
  https://lirantal.com/blog/cors-samesite-csrf-3-dimensions-cookie-authentication
- Cross-site WebSocket hijacking (PortSwigger):
  https://portswigger.net/web-security/websockets/cross-site-websocket-hijacking
- MDN, Using HTTP cookies:
  https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Cookies
