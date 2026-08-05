# Auth Cookie Review Findings and Fix Plan

Status: awaiting approval

Branch reviewed: `auth-cookie`

Target issue: https://github.com/serverpod/serverpod/issues/4045

## Scope

This brief contains the P1 and P2 findings from the branch review and a proposed
implementation plan. It intentionally excludes the P3 whitespace-only finding.
No fixes should be implemented until the decisions at the end are approved.

## Required Invariants

The fixes must preserve all of these behaviors:

1. SAS session tokens never enter JavaScript-readable response bodies or storage
   in cookie mode.
2. JWT refresh tokens never enter JavaScript-readable response bodies or storage
   in cookie mode; access tokens remain tab-local and in memory.
3. `@unauthenticatedClientCall` reaches the server without an authenticated
   session, including when the browser has an SAS auth cookie.
4. HTTP and WebSocket calls use the same current identity after sign-in,
   sign-out, restore, or an account switch.
5. Cross-tab JWT refresh cannot revoke or desynchronize an otherwise valid
   browser session.
6. Existing clients are not broken by an opt-in cookie feature unless that
   break is separately approved and release-gated.
7. The actual browser cookie and CORS flow is covered by an end-to-end test.

## Findings

### P1: Concurrent tabs can invalidate the shared JWT refresh session

The persisted cookie-mode JWT state has a blank access token. Each tab therefore
refreshes on startup using the same browser-managed refresh cookie. The client
mutex is process-local and cannot serialize refreshes across tabs.

The server uses a rotating refresh secret. A request using the previous secret
is treated as credential reuse and deletes the refresh-token row. Concurrent
requests can therefore either revoke the session or leave the browser cookie
and database hash describing different rotations.

Relevant code:

- `modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_client/lib/src/auth_key_providers/jwt_auth_key_provider.dart`
- `modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_server/lib/src/jwt/business/jwt_admin.dart`
- `modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_server/test/jwt/integration/jwt_admin_test.dart`

### P1: `@unauthenticatedClientCall` is authenticated in SAS cookie mode

The generated client suppresses the Authorization header for
`authenticated: false`, but the browser request delegate still sends the cookie
mode marker. The server interprets that marker as permission to read the main
SAS auth cookie, so the method call is authenticated.

This contradicts the annotation contract and changes both observable session
state and `requireLogin` behavior.

Relevant code:

- `packages/serverpod_shared/lib/src/annotations.dart`
- `packages/serverpod_client/lib/src/serverpod_client_shared.dart`
- `packages/serverpod_client/lib/src/serverpod_client_browser.dart`
- `packages/serverpod/lib/src/server/server.dart`

### P1: Method streams retain the cookie identity from the WebSocket handshake

The modern method-stream manager reuses one WebSocket. SAS has no in-band token
in cookie mode, so the server falls back to the cookie captured by the original
handshake. Updating `ClientAuthSessionManager` only updates the deprecated
legacy stream and does not reconnect the method-stream socket.

Consequences:

- A public stream opened before sign-in keeps later protected streams anonymous.
- Switching directly from user A to user B can make later streams run as user A.
- The deprecated legacy streaming API never authenticates SAS cookie mode,
  because its `auth` message carries a null key and the server does not read its
  handshake cookie.

Relevant code:

- `packages/serverpod_client/lib/src/client_method_stream_manager.dart`
- `packages/serverpod_client/lib/src/serverpod_client_shared.dart`
- `packages/serverpod/lib/src/server/websocket_request_handlers/method_websocket_request_handler.dart`
- `packages/serverpod/lib/src/server/websocket_request_handlers/endpoint_websocket_request_handler.dart`
- `modules/serverpod_auth/serverpod_auth_core/serverpod_auth_core_client/lib/src/session_manager.dart`

### P1: The opt-in feature unconditionally breaks legacy authentication

The branch removes the legacy HTTP body/query `auth` fallback and legacy
WebSocket query authentication regardless of whether cookie auth is configured.
The existing backwards-compatibility test was changed from success to a 401.

This is a server upgrade break for older clients and is not required for new
clients to stop placing tokens in URLs. It needs a separate compatibility and
release decision.

Relevant code:

- `packages/serverpod/lib/src/server/server.dart`
- `packages/serverpod/lib/src/server/session.dart`
- `tests/serverpod_test_server/test_e2e/auth_key_backwards_compatibility_test.dart`

### P2: The browser acceptance path is not tested

The new client integration test skips browser platforms and uses a fake
cookie-capable request delegate without a cookie jar. Server tests use mocked
sessions. No test exercises the browser receiving `Set-Cookie`, resending the
cookie with credentialed CORS, restoring JWT access, or clearing cookies.

The design document also records the browser integration test as pending.

Relevant code:

- `packages/serverpod_client/test/integration/call_server_endpoint_cookie_auth_test.dart`
- `docs/design/web_auth_httponly_cookies.md`
- `.github/workflows/dart-tests.yaml`

## Proposed Fix Plan

### Work Package 1: Separate cookie transport from authentication intent

This fixes the `@unauthenticatedClientCall` regression and provides the protocol
signal needed by WebSocket fixes.

Implementation:

1. Add an explicit per-call cookie-auth intent to the client transport API.
   `cookieAuth` continues to mean that the browser should carry cookies, while
   the existing `authenticated` argument determines whether the main SAS cookie
   may authenticate this call.
2. Represent both states on the wire without adding another CORS header:
   - `x-serverpod-auth-mode: cookie` means cookie transport with main SAS cookie
     authentication enabled;
   - `x-serverpod-auth-mode: cookie-transport` means carry/read/write cookies,
     but do not use the main SAS cookie to authenticate the call.
3. Update `ServerpodClientRequestDelegate.serverRequest` to receive the
   per-call intent instead of deriving everything from the client-wide flag.
4. Keep credentialed transport enabled for unauthenticated JWT refresh and
   sign-in calls so they can read or set their dedicated cookies.
5. On the server, distinguish:
   - cookie transport participation, used by cookie issuance and refresh-cookie
     reads;
   - main auth-cookie consumption, disabled for unauthenticated calls.
6. Add the same intent to `OpenMethodStreamCommand`. The server must only fall
   back to the WebSocket handshake auth cookie when that command explicitly
   permits authentication.

Tests first:

1. Extend the existing unauthenticated annotation integration tests with an SAS
   cookie-mode client.
2. Prove HTTP and method-stream annotated calls observe
   `session.authenticated == null`.
3. Prove annotated calls to `requireLogin` endpoints still return 401.
4. Prove JWT refresh remains able to read the refresh cookie even though its
   generated call is unauthenticated.
5. Prove ordinary SAS cookie calls remain authenticated.

Acceptance criteria:

- The complete existing `@unauthenticatedClientCall` behavior matrix passes in
  header mode and cookie mode.
- No auth or refresh token is exposed to JavaScript.

### Work Package 2: Refresh WebSocket authentication on auth-state changes

This fixes stale or absent SAS identities on streaming transports.

Implementation:

1. Add a non-deprecated client hook for authentication-state changes.
2. In cookie mode, close the modern method-stream WebSocket whenever the signed
   in identity or auth strategy changes. The next method stream must create a
   fresh handshake after the browser has processed `Set-Cookie`.
3. Close or reconnect the legacy WebSocket on the same transitions. Do not send
   a null SAS key and pretend the authentication update succeeded.
4. Extend the legacy `auth` control message with cookie-auth intent, or reject
   legacy streaming in cookie mode with a clear `UnsupportedError`. Supporting
   it is recommended while the public API remains available.
5. Close active streams with a specific authentication-changed exception so
   callers can resubscribe intentionally rather than receiving an ambiguous
   connection failure.
6. Apply the same lifecycle on sign-out to prevent a live handshake from
   retaining credentials after local state is cleared.

Tests first:

1. Open an anonymous stream, sign in with SAS, and prove the next protected
   stream is authenticated after reconnection.
2. Open a stream as user A, sign in directly as user B, and prove subsequent
   streams use user B.
3. Sign out with an active stream and prove subsequent streams are anonymous or
   rejected according to endpoint policy.
4. Cover both modern method streams and the chosen legacy-stream behavior.

Acceptance criteria:

- No method stream can use an identity older than the current client auth state.
- Active streams terminate deterministically when authentication changes.

### Work Package 3: Serialize cookie JWT refresh across browser tabs

This fixes refresh rotation races without sharing access tokens across tabs.

Recommended implementation:

1. Add a browser-only refresh coordinator backed by the Web Locks API. The lock
   name must be scoped by the normalized server origin and base path, and must
   never contain a cookie name or token. The browser client does not know the
   server's configured refresh-cookie name.
2. Expose the coordinator through the client transport boundary and inject it
   into `JwtAuthKeyProvider`; keep the auth-core package platform-agnostic.
3. Acquire the cross-tab lock around the complete refresh request and auth-state
   update. The browser must finish processing the first response's `Set-Cookie`
   before the next tab sends its request.
4. Retain the existing in-process mutex inside each client.
5. Make server rotation deterministic with a transaction and row lock so two
   non-cooperating requests cannot both update from the same stale row. Preserve
   current reuse-revocation semantics for genuinely stale or malicious tokens.
6. Define unsupported-browser behavior explicitly. Recommended initial policy:
   fail cookie-mode JWT configuration clearly when cross-tab locking is not
   available, rather than silently reintroducing the destructive race.

Tests first:

1. Add a coordinator unit test proving two client instances serialize refresh.
2. Add a server integration test issuing simultaneous rotations and proving the
   database update is deterministic.
3. Add a browser test with two tabs sharing one refresh cookie. Both tabs must
   obtain separate access tokens, and a later refresh must still succeed.
4. Keep the existing invalid-secret reuse test to ensure malicious replay still
   revokes the refresh token.

Acceptance criteria:

- Simultaneous official-client tab startup cannot revoke the session.
- Access tokens are never broadcast or persisted across tabs.
- Deliberate reuse outside the coordinated browser flow retains the existing
  security response.

### Work Package 4: Restore or release-gate legacy authentication

This resolves the unconditional compatibility break.

Recommended implementation for this branch:

1. Restore the legacy HTTP request-body `auth` fallback. It is not a URL and
   does not conflict with new clients using headers or cookies.
2. Restore legacy query/WebSocket authentication for the current release line,
   while keeping all newly generated clients on the in-band/header path.
3. Add a dedicated configuration flag and deprecation warning if immediate
   operator opt-out is required. Do not silently change the default in a minor
   release.
4. Move final removal of URL/query authentication to a separately approved
   major-version change with migration notes.
5. Restore the original backwards-compatibility expectation and add separate
   tests proving new clients never place tokens in URLs.

Tests first:

1. Restore the valid legacy-client HTTP call test to expect success.
2. Add legacy WebSocket coverage for the query-auth handshake.
3. Add new-client tests that inspect connection URLs and prove no token appears.
4. If a compatibility flag is approved, cover both enabled and disabled modes.

Acceptance criteria:

- A default server upgrade does not reject supported legacy clients.
- New clients never put credentials in HTTP or WebSocket URLs.
- Any eventual break is explicit, configurable during migration, and documented.

### Work Package 5: Add a real browser end-to-end test lane

This validates the actual behavior requested by issue 4045 and covers the other
work packages together.

Implementation:

1. Extend the auth test server with cookie auth enabled, a fixed test origin,
   and endpoints that expose authenticated identity without exposing tokens.
2. Add a browser-targeted auth client test using the real `BrowserClient`, not a
   fake delegate.
3. Run the browser test from a fixed origin/port so credentialed CORS and
   `allowedOrigins` are deterministic in CI.
4. Add the browser case to the existing module E2E workflow for Chrome. Keep VM
   tests for native/header compatibility.

Required scenarios:

1. SAS sign-in sets an HttpOnly cookie and returns a blank token.
2. A later HTTP call authenticates using only the cookie.
3. `@unauthenticatedClientCall` remains anonymous with that cookie present.
4. Sign-out clears the cookie and the next protected call returns 401.
5. JWT sign-in returns an access token but no refresh token.
6. Reload restores access using the refresh cookie.
7. Two tabs refresh without invalidating the session.
8. Method streams reconnect to the current identity after sign-in and switching
   users.
9. A non-allow-listed origin fails CORS/origin validation.

Acceptance criteria:

- The full browser flow passes under both dart2js and dart2wasm where supported
  by the existing CI matrix.
- The test observes behavior only; it never attempts to read HttpOnly cookie
  values from JavaScript.

## Recommended Sequence

1. Add reproducing tests for Work Packages 1 through 4.
2. Implement the per-call authentication intent from Work Package 1.
3. Implement streaming lifecycle changes from Work Package 2.
4. Implement cross-tab JWT coordination and server serialization from Work
   Package 3.
5. Restore or gate legacy behavior from Work Package 4.
6. Add the browser E2E fixture and CI lane from Work Package 5.
7. Run focused package tests, database-backed auth integration tests, browser
   E2E tests, analyzers, formatting, and `git diff --check`.
8. Update the design document, public authentication guide, templates,
   changelogs, and migration notes to describe only verified behavior.

## Approval Decisions

1. Approve splitting cookie transport participation from per-call
   authentication intent.
2. Approve reconnecting and terminating active streams whenever cookie-auth
   identity changes.
3. Approve Web Locks as the official cross-tab JWT refresh coordinator and a
   clear unsupported-browser failure policy.
4. Approve restoring legacy authentication in this branch and moving its final
   removal to a separately approved major-version change.
5. Approve adding a browser E2E/CI lane as a merge requirement for this security
   feature.
