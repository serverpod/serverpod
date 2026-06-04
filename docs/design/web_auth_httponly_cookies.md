# Design: Web Authentication with httpOnly Cookies

Moves Serverpod's web authentication off JavaScript-readable token storage and
onto httpOnly cookies. Consolidates the requirement spike and the phased plans
(issue https://github.com/serverpod/serverpod/issues/4045).

Scope: browser (Flutter/Dart web) clients. Native and desktop clients already use
OS-backed secure storage (Keychain / encrypted shared preferences) and keep
header / in-band authentication; they are unchanged.

## Summary

On web today the auth token is held in JS-readable storage and travels in request
URLs and headers. Target:

- Opaque session token (`AuthStrategy.session`, "SAS"): httpOnly, Secure,
  SameSite cookie.
- JWT: access token in memory, refresh token in an httpOnly, Secure, SameSite
  cookie.

`relic_core` (`relic: ^1.2.0`) already supports cookies: `SetCookieHeader` and
`CookieHeader` with `httpOnly`, `secure`, `sameSite`, `domain`, `path`, `maxAge`
and `expires`, via `headers.setCookie` / `headers.cookie` on requests and
responses. The work is in the server auth pipeline, the auth modules, and the web
client, not the transport.

Delivered in phases. Phase 0 (tokens out of URLs + WebSocket `Origin` validation)
is implemented. Later phases add cookie auth as an opt-in web mode.

## Motivation

`localStorage`, `sessionStorage` and IndexedDB are readable by any JavaScript on
the page. An XSS foothold can exfiltrate the token and replay it from anywhere for
its lifetime.

httpOnly cookies cannot be read by JS. XSS can still ride the session while the
page is open, but cannot steal the credential for later replay. OWASP: "Do not
store session identifiers in local storage as the data is always accessible by
JavaScript. Cookies can mitigate this risk using the httpOnly flag." The common
SPA pattern is access token in memory, refresh token in an httpOnly cookie.

## Current state

### Client token storage (web)

Client auth is behind `ClientAuthKeyProvider.authHeaderValue`
(`packages/serverpod_client/lib/src/auth_key_provider.dart`). The auth-core
client persists `AuthSuccess` via a pluggable `KeyValueStorage`
(`serverpod_auth_core_client/.../storage/key_value_client_auth_success_storage.dart`).
Native clients use OS secure storage; on web there is no secure backing store, so
it lands in JS-readable storage.

### Transport

- HTTP: token in the `authorization` header (`serverpod_client_browser.dart`).
- WebSocket (before Phase 0): token in the connection URL (`?auth=<token>`),
  which leaks to access logs, history and `Referer`.

### Server request authentication

- HTTP: read from the `Authorization` header (and, before Phase 0, a `?auth=`
  query fallback) in `server.dart`. Does not read cookies.
- WS: in-band `auth` control message (legacy `/websocket`) or
  `OpenMethodStreamCommand.authentication` (modern `/v1/websocket`).

### Token issuance

Sign-in returns the token in the JSON response body via `AuthSuccess` (`token`,
optional `refreshToken`, `tokenExpiresAt`, `authStrategy`, `authUserId`,
`scopeNames`). Strategies (`AuthStrategy { jwt, session }`): the opaque SAS token
(`server_side_sessions_token.dart`: `sas` prefix + session UUID + secret) and JWT
access/refresh (`jwt/jwt.dart`).

### Response building

A method-call result becomes `Response.ok(body: ...)` in `server.dart` with the
`MethodCallSession` in scope. `httpResponseHeaders` is a single global (CORS)
`Headers`. There is no API for an endpoint or session to set a response header or
cookie; this must be added for cookie issuance.

### Transport primitives

`relic_core` provides `SetCookieHeader` (name, value, expires, maxAge, domain,
path, secure, httpOnly, sameSite) and `CookieHeader` / `Cookie`. The
in-development relic (the `#113` typed-headers work) is hardening these for
RFC 6265 and changing the API: `SetCookieHeader.domain` becomes a `Host?`
(host-only, section 5.2.3), `path` a validated `String?`, and the constructor
validates `name` / `value` / `domain` / `path`. Target that post-`#113` API and
sequence cookie work after the relic release that ships it.

## Goals and non-goals

Goals: secure storage and transport for browser clients (SAS and JWT); opt-in (no
forced break until a major); cross-subdomain support.

Non-goals here: native/mobile/desktop storage; a BFF / OAuth-confidential-client
rearchitecture; changes to the auth providers (email, OAuth, passkeys).

## Target design

### Token placement

```
+----------------------+---------------------------------+---------------------------------+
| Strategy             | Access / session token          | Refresh token                   |
+======================+=================================+=================================+
| JWT                  | In memory (re-minted on load)   | HttpOnly Secure SameSite cookie |
| Opaque session (SAS) | HttpOnly Secure SameSite cookie | n/a (server-side session)       |
+----------------------+---------------------------------+---------------------------------+
```

"In memory" means not in `localStorage`, `sessionStorage`, or a non-httpOnly
cookie. On load the SPA calls a refresh endpoint; the browser sends the refresh
cookie and the server returns a fresh access token in the body.

### Server flow

- Sign-in / refresh: set the cookie via `response.headers.setCookie` with
  `httpOnly: true, secure: true, sameSite: SameSite.lax, path: '/'` and a derived
  `maxAge`. For JWT, also return the access token in the body.
- Authenticated request: after the `Authorization`-header check, fall back to the
  configured cookie from `request.headers.cookie`. Token format is unchanged, so
  the existing `AuthenticationHandler` is reused.
- Logout: `Set-Cookie` with `maxAge: 0`; for SAS also destroy the server-side
  session.

### WebSocket / streaming

Browsers attach cookies to the WS handshake automatically (same-origin or
`Domain`-scoped), so streaming authenticates from the handshake cookie, with no
URL token and no in-band message. The Phase 0 `Origin` check covers CSWSH.

### Web client

- Credentialed requests (`withCredentials` / `credentials: 'include'`) so the
  browser sends and stores the cookie.
- A web `CookieClientAuthKeyProvider` whose `authHeaderValue` returns null and
  stores no token.
- CORS: when `authCookie` is set, the server echoes a specific
  `Access-Control-Allow-Origin` (the request `Origin` when it is in
  `allowedOrigins`) plus `Access-Control-Allow-Credentials: true` and
  `Vary: Origin`, since the wildcard `*` is invalid with credentials.
  `allowedOrigins` is the single trusted-origins list, shared with the
  WebSocket handshake `Origin` check.

### Cross-subdomain

`Domain=.example.com` lets the cookie reach `app.example.com`, `api.example.com`,
etc. `SameSite=Lax`/`Strict` treats sibling subdomains of the same registrable
domain as same-site, so this works without `SameSite=None`. A config knob.

## Security considerations

Cookie auth reintroduces CSRF (header/bearer auth is immune since the browser
never auto-attaches it). Defenses:

1. SameSite on the auth cookie. `Lax` (default) blocks cross-site POST; `Strict`
   breaks link-into-authed-page and OAuth redirect returns; `None` only for
   cross-site embedding (forces `Secure`).
2. Origin / Referer validation on state-changing requests and the WS handshake.
   SameSite alone does not fully cover CSWSH. The WS `Origin` check ships in
   Phase 0.
3. Optional double-submit CSRF token for `SameSite=None`.

httpOnly stops token theft but not session riding (an XSS payload can issue
authenticated requests while the page is open); mitigate with CSP and dependency
hygiene. A BFF (no tokens in the browser) is the option for stricter
requirements.

## Implementation roadmap

### Phase 0: tokens out of URLs + WebSocket Origin validation (implemented)

Standalone breaking change, independent of the relic cookie release.

- Streaming clients authenticate in-band via the `auth` control message instead
  of `?auth=` (`serverpod_client_shared.dart`).
- The server no longer reads `auth` from the URL: streaming session
  (`session.dart`) and HTTP query fallback (`server.dart`).
- The legacy streaming handler opens endpoint streams on the first received
  message (after in-band auth is applied) so `streamOpened` sees the
  authenticated session (`endpoint_websocket_request_handler.dart`).
- `allowedOrigins` config (YAML list, comma-separated string, or
  `SERVERPOD_ALLOWED_ORIGINS`). When set, browser WS handshakes with a
  disallowed `Origin` get 403; requests without an `Origin` (native /
  server-to-server) are allowed.

Breaking: `?auth=` is no longer accepted; `streamOpened` for the legacy streaming
API fires on the first message rather than at connect.

### Phase 1: httpOnly-cookie session (opaque / SAS strategy)

SAS first: one opaque token, no in-memory access token, no client-driven refresh;
move the carrier to a cookie.

Prerequisite: a session-scoped response-output API on `Session`
(`setResponseHeader(name, value)` and `setResponseCookie(SetCookieHeader)`),
collected during a call and applied when the framework builds the method-call
`Response`. Cookies use relic's `SetCookieHeader` (already exported by
`serverpod`) and its encoder; removing a cookie is just a `SetCookieHeader` with
`maxAge: 0`. Phase 2 reuses it for the refresh cookie.

Decision: expose a narrow output API (headers + cookies, and possibly a status
override) rather than handing endpoints the relic `Response`. Rationale:

- The `Response` is built after the method returns (`server.dart`), so there is
  nothing to hand out mid-call; intent-collection applied at build time is the
  natural fit.
- For RPC endpoints the framework owns the response envelope (status,
  content-type, serialized body); a header/cookie API constrains endpoints to the
  safe surface and prevents clobbering the protocol.
- The cookie value type is relic's `SetCookieHeader`, not a parallel one: relic
  is already re-exported by `serverpod` and is Serverpod-maintained, so a wrapper
  would only duplicate it. The cookie API churn (`#113`) is handled as a
  coordinated relic upgrade (see sequencing), not by abstracting relic away.
- Generalizes across transports: the same emitted headers/cookies apply to the
  HTTP response or the WebSocket handshake response, whereas a raw `Response`
  accessor is meaningless on streaming sessions.
- Full-response control already has homes for the cases that need it:
  `sendAsRaw` endpoints (`_toResponse`) and web `Route.handleCall`, which returns
  a `Response`.

```
+---------------------+--------------------------------------------------+--------+
| Area                | Change                                           | Effort |
+=====================+==================================================+========+
| Response output API | session.setResponseHeader/Cookie; apply at build | M      |
| Cookie config       | WebAuthCookieConfig (reuse origins plumbing)     | M      |
| HTTP auth read      | Cookie fallback after Authorization header       | S      |
| WS handshake read   | Cookie fallback when no in-band auth             | M      |
| Sign-in/out issue   | Set/clear cookie in auth-core sessions           | M-L    |
| Web client creds    | withCredentials / credentials: include           | S-M    |
| Web auth provider   | CookieClientAuthKeyProvider (null header)        | M      |
| CORS credentials    | Allow-Credentials + specific-origin echo         | S-M    |
| Docs / tests        | Web-auth guide + unit/integration tests          | M      |
+---------------------+--------------------------------------------------+--------+
```

Build order (commit per step):

1. Response output API (setResponseHeader/Cookie) (+ unit tests, no behavior change).
2. `WebAuthCookieConfig` plumbing (+ parse tests).
3. Server cookie read for HTTP + WS (+ tests).
4. CORS credentials.
5. Auth-core sign-in/out + web client `withCredentials` + `CookieClientAuthKeyProvider`.
6. Integration test (web sign-in sets cookie; a call authenticates via the
   cookie; sign-out clears it; native header path unchanged).
7. Docs + sample.

### Phase 2: JWT (access-in-memory + refresh cookie)

Access token in memory, refresh token in an httpOnly cookie with server-side
rotation (refresh token never transits JS). On load the SPA calls a refresh
endpoint; the browser sends the refresh cookie and the server returns a fresh
access token in the body. Reuses the Phase 1 primitive and config.

### Phase 3: cross-subdomain + optional CSRF token + guidance

Cross-subdomain `Domain` config; optional double-submit CSRF token for
`SameSite=None`; BFF guidance.

## Open decisions

1. How a request opts into cookie mode (config flag, client-sent marker, or
   per-endpoint) so native clients keep body/header tokens. Leaning: config flag
   plus a client-side signal.
2. Whether to keep returning `AuthSuccess.token` in the body in cookie mode.
   Leaning: omit for cookie clients, keep for header clients.
3. SameSite default (`Lax`) and whether to expose `Strict` / `None`.
4. Cookie `Domain` default (host-only) vs cross-subdomain; `secure` relaxation for
   `http://localhost`.
5. CSRF posture for HTTP: `SameSite=Lax` + Origin check, or also a double-submit
   token.
6. Session TTL to cookie `Max-Age` mapping; rotation on activity.
7. Relic sequencing: target the post-`#113` cookie API and gate cookie phases on
   that release.

## Dependencies

relic `#113` (RFC-compliant typed headers) for the final cookie API shape. No new
third-party libraries.

## Sources

- OWASP, JSON Web Token Cheat Sheet:
  https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html
- OWASP, WebSocket Security Cheat Sheet:
  https://cheatsheetseries.owasp.org/cheatsheets/WebSocket_Security_Cheat_Sheet.html
- Curity, OAuth for SPAs / BFF:
  https://curity.io/resources/learn/spa-best-practices/
- Token storage, localStorage vs httpOnly cookies (wisp):
  https://www.wisp.blog/blog/understanding-token-storage-local-storage-vs-httponly-cookies
- Web Authentication: Three Decisions You're Conflating (wempe.dev):
  https://wempe.dev/blog/authentication-cookie-vs-token-based
- CORS, SameSite and CSRF (Liran Tal):
  https://lirantal.com/blog/cors-samesite-csrf-3-dimensions-cookie-authentication
- Cross-site WebSocket hijacking (PortSwigger):
  https://portswigger.net/web-security/websockets/cross-site-websocket-hijacking
- Sending cookies to a WebSocket backend (Medium):
  https://charithcj.medium.com/how-to-send-cookies-from-browser-to-websocket-backend-and-why-you-cant-see-them-in-chrome-b383b53b22fa
- MDN, Using HTTP cookies:
  https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Cookies
- SameSite and subdomains:
  https://medium.com/@rramgattie/samesite-and-subdomains-08870bbdd62c
