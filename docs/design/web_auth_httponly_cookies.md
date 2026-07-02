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

`relic` supports cookies: a `SetCookie` carries `httpOnly`, `secure`,
`sameSite`, `domain`, `path`, `maxAge` and `expires`, and a response's
`SetCookieHeader` is the collection of them (`CookieHeader` / `Cookie` on the
request side), via `headers.setCookie` / `headers.cookie` on responses and
requests. The work is in the server auth pipeline, the auth modules, and the web
client, not the transport.

Delivered in phases:

- Phase 0 (tokens out of URLs + WebSocket `Origin` validation) is implemented.
- Phase 1 (opt-in httpOnly cookie auth for the opaque SAS strategy) is
  implemented: response-output API, cookie config, server cookie read (HTTP and
  the modern WebSocket handshake), credentialed CORS, sign-in/out cookie
  issuance, and the web client wiring.
- Phase 2 (JWT access-in-memory + refresh cookie) and Phase 3 (cross-subdomain
  `Domain` + optional CSRF token) are not yet started.

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
for header-mode clients it lands in JS-readable storage. A cookie-mode web client
(`ClientAuthSessionManager(cookieAuth: true)`) returns a null `authHeaderValue`
and relies on the browser-held httpOnly cookie instead, so no token reaches JS.

### Transport

- HTTP: header-mode clients send the token in the `authorization` header
  (`serverpod_client_browser.dart` / `serverpod_client_io.dart`); cookie-mode
  clients send the `x-serverpod-auth-mode: cookie` marker (and, on web, a
  credentialed request) and carry the token in the httpOnly cookie instead.
- WebSocket: token sent in-band via the `auth` control message
  (`serverpod_client_shared.dart`), or, for browser cookie clients, attached
  automatically to the handshake as a cookie. The token no longer appears in the
  connection URL (Phase 0).

### Server request authentication

- HTTP (`server.dart`): read from the `Authorization` header. When `authCookie`
  is configured, fall back to the auth cookie, but only for a request that
  carries the `x-serverpod-auth-mode: cookie` marker and whose `Origin` (if
  present) is allow-listed; otherwise the ambient cookie is ignored. The `?auth=`
  query fallback was removed in Phase 0.
- WS: every handshake is `Origin`-checked against `allowedOrigins`. The modern
  `/v1/websocket` handler (`method_websocket_request_handler.dart`) accepts the
  in-band `OpenMethodStreamCommand.authentication` and falls back to the
  handshake auth cookie. The legacy `/websocket` handler
  (`endpoint_websocket_request_handler.dart`) authenticates in-band via the
  `auth` control message only (no cookie read).

### Token issuance

Sign-in returns the token via `AuthSuccess` (`token`, optional `refreshToken`,
`tokenExpiresAt`, `authStrategy`, `authUserId`, `scopeNames`). Strategies
(`AuthStrategy { jwt, session }`): the opaque SAS token
(`server_side_sessions_token.dart`: `sas` prefix + session UUID + secret) and JWT
access/refresh (`jwt/jwt.dart`). For a cookie-mode request the SAS sign-in
(`server_side_sessions.dart`) writes the token as a `Set-Cookie` and returns an
empty `token` in the body, so it never reaches JS. JWT issuance is unchanged
(Phase 2).

### Response building

A method-call result becomes `Response.ok(body: ...)` (or `_toResponse` for
`sendAsRaw`) in `server.dart` with the `MethodCallSession` in scope.
`httpResponseHeaders` is a single global (CORS) `Headers`. A session now also has
a response-output API: `Session.setResponseHeader(name, value)` and
`Session.setResponseCookie(SetCookie)` collect intent during the call, and
`applyResponseOutput` (`response_output.dart`) applies it when the framework
builds the response (values set here take precedence; default headers merge
underneath; cookies append to any existing `Set-Cookie`).

### Transport primitives

`relic` provides `SetCookie` (name, value, expires, maxAge, domain, path,
secure, httpOnly, sameSite), the `SetCookieHeader` collection that holds them on
a response, and `CookieHeader` / `Cookie` on the request. The cookie code uses
relic 2.0's RFC-6265-hardened cookie API: `SetCookie.domain` is a `Host?`
(host-only, section 5.2.3) and the constructor validates `name` / `value` /
`domain` / `path`, throwing `FormatException` on bad input -- it also normalizes
away a leading dot on the `Domain` (`.example.com` -> `example.com`) and rejects a
port. `auth_cookie.dart` hands the configured domain straight to `Host.parse` and
rethrows a clear `ArgumentError` so a malformed operator config fails fast rather
than deep in the sign-in path.

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
| JWT (Phase 2)        | In memory (re-minted on load)   | HttpOnly Secure SameSite cookie |
| Opaque session (SAS) | HttpOnly Secure SameSite cookie | n/a (server-side session)       |
+----------------------+---------------------------------+---------------------------------+
```

"In memory" means not in `localStorage`, `sessionStorage`, or a non-httpOnly
cookie. On load the SPA calls a refresh endpoint; the browser sends the refresh
cookie and the server returns a fresh access token in the body.

### Server flow

- Sign-in / refresh: set the cookie via `session.setResponseCookie` (the
  `writeWebAuthCookie` helper) with `httpOnly: true`, `secure`, `sameSite`,
  `domain` and `path` from `WebAuthCookieConfig`, and a `maxAge` derived from the
  token's expiry (a session cookie when the expiry is absent or non-positive). For
  JWT, also return the access token in the body (Phase 2).
- Authenticated request: after the `Authorization`-header check, fall back to the
  configured cookie from `request.headers.cookie` (gated on the marker header and
  the `Origin` check). Token format is unchanged, so the existing
  `AuthenticationHandler` is reused.
- Logout: `clearWebAuthCookie` emits a `Set-Cookie` with `maxAge: 0`; for SAS
  also destroy the server-side session.

### WebSocket / streaming

Browsers attach cookies to the WS handshake automatically (same-origin or
`Domain`-scoped), so streaming on the modern `/v1/websocket` handler
authenticates from the handshake cookie, with no URL token and no in-band
message. The Phase 0 `Origin` check covers CSWSH.

### Web client

- Credentialed requests (`withCredentials` on the browser `http` client) so the
  browser sends and stores the cookie, plus the `x-serverpod-auth-mode: cookie`
  marker header on every call.
- A `CookieAuthKeyProvider` capability interface (`auth_key_provider.dart`): a
  provider that reports `usesCookies == true` makes the client send the marker /
  credentialed request and attach no `Authorization` header. The auth-core
  `ClientAuthSessionManager` implements it behind a `cookieAuth` flag and returns
  a null `authHeaderValue` in that mode.
- CORS: when `authCookie` is set, the server echoes a specific
  `Access-Control-Allow-Origin` (the request `Origin` when it is in
  `allowedOrigins`) plus `Access-Control-Allow-Credentials: true` and
  `Vary: Origin`, since the wildcard `*` is invalid with credentials. For a
  present-but-non-allow-listed browser `Origin` the default wildcard
  `Access-Control-Allow-Origin` is dropped rather than echoed, so enabling cookie
  auth requires every cross-origin browser caller -- including callers of public
  endpoints -- to be in `allowedOrigins`. The marker header is added to the
  allowed CORS request headers, and re-added when a custom
  `httpOptionsResponseHeaders` override omits it (`serverpod.dart`).
  `allowedOrigins` is the single trusted-origins list, shared with the WebSocket
  handshake `Origin` check.

### Cross-subdomain

`Domain=.example.com` lets the cookie reach `app.example.com`, `api.example.com`,
etc. `SameSite=Lax`/`Strict` treats sibling subdomains of the same registrable
domain as same-site, so this works without `SameSite=None`. Exposed via the
`authCookie.domain` config knob (host-only by default); RFC 6265 sends the
`Domain` attribute without a leading dot, so a configured `.example.com` is
normalized to `example.com`.

## Security considerations

Cookie auth reintroduces CSRF (header/bearer auth is immune since the browser
never auto-attaches it). The chosen posture is defense in depth: SameSite +
Origin validation + a marker-header requirement, with a double-submit token held
in reserve for `SameSite=None`. Defenses:

1. SameSite on the auth cookie. `Lax` (default) blocks cross-site POST; `Strict`
   breaks link-into-authed-page and OAuth redirect returns; `None` only for
   cross-site embedding (config rejects `None` without `Secure`, since browsers
   drop such a cookie). SameSite alone does not cover a same-registrable-domain
   sibling subdomain, which the next two layers do.
2. Origin validation on state-changing requests and the WS handshake, against
   `allowedOrigins`. A request whose `Origin` is present but not allow-listed is
   rejected (403); a missing `Origin` (native / server-to-server) is allowed.
   Both the WS handshake check and the HTTP cookie-auth check are implemented
   (`server.dart`), independent of the browser's own CORS enforcement.
3. Marker-header requirement: the server reads the auth cookie only when the
   request carries `x-serverpod-auth-mode: cookie`. A cross-site form or simple
   request cannot set a custom header without a CORS preflight, which fails for
   non-allow-listed origins, so the ambient cookie never authenticates a
   cross-site HTTP request. (WebSocket handshakes cannot send custom headers, so
   the WS path relies on the Origin check in layer 2 instead.)
4. Optional double-submit CSRF token for `SameSite=None`, deferred to Phase 3.

The cookie read also fails closed on an ambiguous `Cookie` header: when more than
one cookie carries the configured name (e.g. a sibling subdomain plants a
`Domain`-scoped duplicate that shadows the host-only cookie), `getCookieValue`
returns null (logging a warning) rather than trusting whichever the browser
ordered first (`request_extension.dart`).

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
- The legacy streaming handler opens endpoint streams on the `auth` control
  message, which the client sends as its first frame (with a null key when
  anonymous); a ping does not open them, and an endpoint message before the
  handshake opens them anonymously as a fallback. This lets `streamOpened`
  observe the settled auth state (`endpoint_websocket_request_handler.dart`).
- `allowedOrigins` config (YAML list, comma-separated string, or
  `SERVERPOD_ALLOWED_ORIGINS`). When set, browser WS handshakes with a
  disallowed `Origin` get 403; requests without an `Origin` (native /
  server-to-server) are allowed.

Breaking: `?auth=` is no longer accepted; `streamOpened` for the legacy streaming
API fires on the `auth` handshake (or the first endpoint message) rather than at
connect.

### Phase 1: httpOnly-cookie session (opaque / SAS strategy) (implemented)

SAS first: one opaque token, no in-memory access token, no client-driven refresh;
the carrier moved to a cookie. Opt-in: the server needs an `authCookie` section
and the client must run in `cookieAuth` mode; otherwise the header path is
unchanged.

Decision: expose a narrow output API (headers + cookies) rather than handing
endpoints the relic `Response`. Rationale:

- The `Response` is built after the method returns (`server.dart`), so there is
  nothing to hand out mid-call; intent-collection applied at build time is the
  natural fit.
- For RPC endpoints the framework owns the response envelope (status,
  content-type, serialized body); a header/cookie API constrains endpoints to the
  safe surface and prevents clobbering the protocol.
- The cookie value type is relic's `SetCookie`, not a parallel one: relic
  is already re-exported by `serverpod` and is Serverpod-maintained, so a wrapper
  would only duplicate it. The cookie API churn (`#113`) is handled as a
  coordinated relic upgrade (see sequencing), not by abstracting relic away.
- Generalizes across transports: the same emitted headers/cookies apply to the
  HTTP response or the WebSocket handshake response, whereas a raw `Response`
  accessor is meaningless on streaming sessions.
- Full-response control already has homes for the cases that need it:
  `sendAsRaw` endpoints (`_toResponse`) and web `Route.handleCall`, which returns
  a `Response`.

What shipped:

```
+---------------------+--------------------------------------------------+-----------+
| Area                | Change                                           | Status    |
+=====================+==================================================+===========+
| Response output API | session.setResponseHeader/Cookie; apply at build | done      |
| Cookie config       | WebAuthCookieConfig + allowedOrigins plumbing    | done      |
| HTTP auth read      | Cookie fallback (marker + Origin gated)          | done      |
| WS handshake read   | Cookie fallback on modern /v1/websocket          | done      |
| Sign-in/out issue   | Set/clear cookie in auth-core SAS sessions       | done      |
| Web client creds    | withCredentials + marker header                  | done      |
| Web auth provider   | CookieAuthKeyProvider + ClientAuthSessionManager | done      |
| CORS credentials    | Allow-Credentials + specific-origin echo + Vary  | done      |
| Unit tests          | auth_cookie / response_output / config tests     | done      |
| Integration test    | Web sign-in -> cookie -> authed call -> sign-out | pending   |
| Docs / sample       | This design doc done; user guide + sample        | pending   |
+---------------------+--------------------------------------------------+-----------+
```

Design divergence to note: the web auth provider was implemented as a
`CookieAuthKeyProvider` capability interface plus a `cookieAuth` flag on the
existing `ClientAuthSessionManager`, rather than a separate
`CookieClientAuthKeyProvider` class as first sketched. The manager still uses the
pluggable storage but returns a null `authHeaderValue` in cookie mode. This keeps
one session-manager type for header and cookie clients instead of forking it.

Config (server `config/<run-mode>.yaml`, or `SERVERPOD_*` env vars):

```
authCookie:
  name: serverpod_auth   # default
  domain:                # host-only by default; set .example.com to share
  path: /                # default
  secure: true           # default; set false only for http://localhost
  sameSite: lax          # lax (default) | strict | none (none requires secure)
allowedOrigins:
  - https://app.example.com
```

`authCookie` requires a non-empty `allowedOrigins` (it backs the CSWSH guard and
credentialed CORS, which cannot use the wildcard origin); the config constructor
throws otherwise. Env equivalents: `SERVERPOD_AUTH_COOKIE_NAME`,
`SERVERPOD_AUTH_COOKIE_DOMAIN`, `SERVERPOD_AUTH_COOKIE_PATH`,
`SERVERPOD_AUTH_COOKIE_SECURE`, `SERVERPOD_AUTH_COOKIE_SAME_SITE`,
`SERVERPOD_ALLOWED_ORIGINS`.

Remaining for Phase 1: an end-to-end integration test (web sign-in sets the
cookie; a call authenticates via the cookie; sign-out clears it; native header
path unchanged) and a web-auth user guide plus sample.

### Phase 2: JWT (access-in-memory + refresh cookie)

Access token in memory, refresh token in an httpOnly cookie with server-side
rotation (refresh token never transits JS). On load the SPA calls a refresh
endpoint; the browser sends the refresh cookie and the server returns a fresh
access token in the body. Reuses the Phase 1 primitive and config.

### Phase 3: cross-subdomain + optional CSRF token + guidance

Cross-subdomain `Domain` config is already in place at the cookie level;
remaining: optional double-submit CSRF token for `SameSite=None`; BFF guidance.

## Open decisions

1. How a request opts into cookie mode: resolved. The client runs in `cookieAuth`
   mode and sends `x-serverpod-auth-mode: cookie`; the server enables it via the
   `authCookie` config section. Native clients keep body/header tokens.
2. Whether to keep returning `AuthSuccess.token` in the body in cookie mode:
   resolved. Omitted (empty `token`) for cookie clients, kept for header clients.
3. SameSite default (`Lax`) and exposing `Strict` / `None`: resolved
   (`CookieSameSite` enum, default `lax`; `none` validated to require `secure`).
4. Cookie `Domain` default: resolved. Host-only by default; cross-subdomain via
   `authCookie.domain`. `secure` relaxation for `http://localhost` is via
   `authCookie.secure: false`.
5. CSRF posture for HTTP: resolved. `SameSite=Lax` + server-side Origin
   validation + a marker-header requirement on the cookie read (layers 1-3
   above). A double-submit token stays reserved for `SameSite=None` (Phase 3).
6. Session TTL to cookie `Max-Age` mapping: resolved. Derived from the token's
   `tokenExpiresAt` (seconds until expiry), falling back to a session cookie for
   a non-positive lifetime. Rotation on activity is deferred.
7. Relic sequencing: resolved. The `#113` work shipped in relic 2.0; the pubspec
   is pinned to `relic: ^2.0.0-beta.0` and the temporary
   `dependencyOverridePaths` override has been removed (see Dependencies).

## Dependencies

relic 2.0 (RFC-compliant typed headers, the `#113` work) provides the final
cookie API shape. The pubspec is pinned to `relic: ^2.0.0-beta.0` across
`serverpod`, `serverpod_client`, `serverpod_test_server` and the templates; the
earlier temporary melos `dependencyOverridePaths` to a local relic checkout has
been removed. No new third-party libraries.

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
