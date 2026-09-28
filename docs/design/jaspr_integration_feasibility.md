# Serverpod + Jaspr Integration: Feasibility Assessment

## Purpose

Assesses whether the developer experience described in [jaspr_integration.md](jaspr_integration.md) can be built on top of today's Jaspr CLI, with `serverpod start` owning a Jaspr development process, forwarding its output to the TUI, and exposing the Jaspr app through the Serverpod web server.

This is an internal companion to the user-facing spec. It records what was verified, what Serverpod has to build, and what should be raised with the Jaspr maintainers.

## Summary

The integration is feasible today by supervising `jaspr serve --verbose`, as long as Serverpod owns shutdown of the whole Jaspr process tree.

- **Logs:** `--verbose` disables the progress spinner, so piped output is newline-delimited, tagged (`[CLI]`, `[BUILDER]`, `[SERVER]`) and free of ANSI codes. It can be forwarded to the TUI without a machine protocol.
- **Public origin:** when the forwarding route sets `X-Forwarded-Host` and `X-Forwarded-Proto`, Jaspr's live-reload channel uses Serverpod's public origin. The browser never contacts Jaspr's internal ports, and no JavaScript has to be rewritten.
- **Shutdown:** this is the real gap. Signaling only the `jaspr serve` process orphans its SSR server. A crashed supervisor orphans it too, in every mode tested. Serverpod has to terminate the process tree itself, and a robust fix needs Jaspr changes.
- **`jaspr daemon`:** the hidden machine mode is not usable as-is. With `--no-launch-in-chrome` it crashes the first time a browser connects. Its default mode launches Jaspr's own Chrome at the internal port instead.

Running `jaspr serve` as a child keeps the promise of not duplicating Jaspr tooling. Serverpod adds a forwarding route and process supervision; building, SSR, file watching and reload stay in Jaspr.

## Validation

- `jaspr_cli` 0.23.5 and `jaspr` 0.23.5, the latest release at the time of writing (published 2026-09-25).
- Dart SDK 3.12.2, Linux.
- A `jaspr.mode: server` app with `jaspr_router`, run with custom ports so it could not collide with Serverpod defaults.
- Process, port and protocol behavior was probed from the shell.
- Browser behavior was validated separately in an isolated Chromium, both directly and through a small HTTP forwarding proxy that stands in for a Serverpod route. No Serverpod route has been implemented.

## Recommended mechanism

```bash
jaspr serve --verbose --port <ssr-port> --proxy-port <proxy-port>
```

- Serverpod allocates `--port` and `--proxy-port` per configured Jaspr app.
- The Serverpod forwarding route sends requests to `<ssr-port>` with `X-Forwarded-Host` and `X-Forwarded-Proto` set to the public origin, and streams responses.
- Serverpod starts the child so that its whole process tree can be signaled, and stops it by signaling that tree (see [Shutdown](#shutdown)).

### Log format

With `--verbose`, and stdout not a terminal:

```text
[CLI] Starting web compilers...
[BUILDER] Starting initial build...
[CLI] Done building web assets.
[CLI] Starting server...
[SERVER] The Dart VM service is listening on http://127.0.0.1:8181/.../
[SERVER] [INFO] Server hot reload is enabled.
[SERVER] Serving at http://localhost:18080
```

- Info goes to stdout; warnings and errors go to stderr (`jaspr_cli lib/src/logging.dart`). Ordering across the two streams is not guaranteed.
- Build state is only available as text: `Building web assets...`, `Rebuilt web assets.`, `Failed building web assets`.
- `--verbose` also shows verbose-level builder output, so the TUI may want to demote `[BUILDER]` lines.
- Without `--verbose`, piped output is mason spinner frames joined with `\r`, which is not usable.

## Verified behavior

### Startup and SSR

The first build takes around 40 seconds, mostly compiling builders; later starts reuse the build cache. The SSR server then comes up on the assigned port and serves a 200 response with SSR HTML. Serverpod should show the first build as a launching state, as it already does for Flutter.

### Edit cycle

Editing a page file produced a client rebuild and an SSR hot reload:

```text
[CLI] Rebuilding web assets...
[SERVER] [INFO] Server application reloaded.
[CLI] Rebuilt web assets.
```

In the browser validation, `jaspr serve --verbose` behind the forwarding proxy refreshed the page automatically after an edit.

### Public origin through a forwarding proxy

dwds builds the live-reload endpoint from `request.requestedUri` (`dwds lib/src/handlers/injector.dart:71-87`). dart:io reconstructs `requestedUri` from `X-Forwarded-Host` and `X-Forwarded-Proto`. Jaspr's SSR server forwards request headers to its proxy, so the headers set by Serverpod reach dwds:

```text
GET /main.client.dart.bootstrap.js
  X-Forwarded-Host: serverpod.example.test:8082
  X-Forwarded-Proto: https

window.$dwdsDevHandlerPath = "https://serverpod.example.test:8082/$dwdsSseHandler";
```

Jaspr's own bootstrap rewrite (`jaspr_cli lib/src/helpers/proxy_helper.dart:63`) only replaces `http://localhost:<proxy-port>/`, so it leaves a forwarded origin alone.

In the browser validation through the proxy:

- The live-reload stream (`GET $dwdsSseHandler`) and its messages (`POST $dwdsSseHandler`) went through the public port and returned 200.
- The page refreshed after an edit.
- The browser made no requests to Jaspr's internal ports.

Without the forwarded headers, the endpoint falls back to `http://localhost:<ssr-port>/$dwdsSseHandler` and the browser talks to Jaspr directly. That works on localhost only because Jaspr's live-reload channel returns CORS headers for any origin.

### Shutdown

| Scenario | Result |
|---|---|
| SIGINT or SIGTERM to the `jaspr serve` pid only | `jaspr serve` exits after `Shutting down...` and `Terminating web compilers...`. The SSR server (`server_target.dart`) is orphaned and stays bound to its port. |
| SIGINT to the whole process group of `jaspr serve` | Everything exits and all ports are released. The SSR server stays in `jaspr serve`'s process group. |
| `jaspr daemon`: `daemon.shutdown` command | Clean exit 0. SSR server, DDS and build daemon are all gone. |
| `jaspr daemon`: stdin closed while stdout is still being read | Clean exit 0, same as above. |
| The supervising process is killed, closing all of the child's pipes (`jaspr daemon`) | The daemon exits, but the SSR server is still listening 8 seconds later. The cause is not confirmed; losing the output pipe is the likely factor. |

In a terminal, Ctrl+C signals the whole foreground process group, which hides the orphaning from standalone Jaspr users. A supervisor signals only its child unless it arranges otherwise. `.dart_tool/jaspr/server.pid` is created and truncated at startup but never written (`dev_command.dart:167-171`), so it cannot be used to find the SSR server.

### VM service port collision

The SSR server's VM service uses the default port 8181 (`--enable-vm-service` without a port, `dev_command.dart:179`). With 8181 already taken:

- stderr shows `[SERVER] [ERROR] Could not start the VM service: ... 127.0.0.1:8181`.
- The SSR debugger address is never published.
- SSR hot reload still works, and edits show up in the rendered HTML.

## Why not `jaspr daemon` today

`jaspr daemon` is a hidden sibling of `jaspr serve` that exists for Jaspr's VS Code extension. It speaks a line-delimited JSON protocol (`[{"event": ...}]` on stdout, commands on stdin, protocol version `0.4.2`) with `daemon.shutdown`, `server.started` and `server.log` events. That would be the ideal supervision interface, but today:

- **`--no-launch-in-chrome` crashes on the first browser connection.** When debugging is disabled, `DevProxy` runs the app's `main` on connect (`jaspr_cli lib/src/dev/dev_proxy.dart:34`). The daemon also always registers `ClientDomain`, which runs `main` again (`lib/src/dev/client_domain.dart:221`). dwds throws `Bad state: Main has already started.`, which is unhandled, and the daemon exits with code 255. Reproduced with a direct browser connection and through the proxy.
- **The default mode launches Jaspr's own Chrome** at `localhost:<ssr-port>` (`dev_command.dart:264`), not at Serverpod's URL. It also waits for that Chrome's debug connection before starting the app.
- **`daemon.log` is a pre-rendered string.** Tag, level and color are baked into the text, and color codes appear as literal `\033[36m` text. It is no more structured than `serve --verbose`.

`jaspr serve` without `--launch-in-chrome` does not register `ClientDomain`, so it only runs `main` once and does not hit the crash.

## Gaps and upstream asks

| # | Gap | Serverpod workaround | Suggested Jaspr change |
|---|---|---|---|
| 1 | Signaling `jaspr serve` orphans the SSR server. | Start the child in its own process group and signal the group on POSIX. Windows needs a separate approach, not yet validated. | Terminate the SSR server before the command completes, so every cleanup guard runs on SIGINT/SIGTERM. |
| 2 | A crashed supervisor leaves the SSR server running, in every mode tested. | Record child pids in Serverpod's runner state and clean up stale ones on the next `serverpod start`. Report a clear error when an assigned port is still in use. | Make the SSR server exit when its parent goes away, for example when its stdin pipe closes. Write the SSR pid to `.dart_tool/jaspr/server.pid`. |
| 3 | `jaspr daemon --no-launch-in-chrome` crashes when a browser connects. | Use `jaspr serve --verbose`. | Run `main` from only one place when `ClientDomain` is registered, or guard `runMain`. |
| 4 | There is no supported machine-readable mode. Logs are text, split across stdout and stderr, and build state is only available as text. | Parse `[TAG]` prefixes and known build messages. | Make the daemon a supported, documented contract (for example `jaspr serve --machine`) with structured `tag`/`level` fields and app-level `build.started` / `build.succeeded` / `build.failed` events. |
| 5 | The SSR server's VM service is fixed at port 8181. A second Jaspr app loses its SSR debugger and logs a spurious `[ERROR]`. | Downgrade that specific error in the TUI. | Use `--enable-vm-service=0`, as Serverpod already does for its own server (`tools/serverpod_cli/lib/src/commands/start/server_process.dart:120`). |
| 6 | Port defaults collide. `--port` defaults to 8080, the Serverpod API port. `--proxy-port` defaults to 5567 for every app. `--web-port` is declared but never read (`dev_command.dart:50`). Embedded Flutter mode hardcodes 5678 (`lib/src/project.dart:298`), so two `jaspr.flutter: embedded` apps cannot run together. | Always pass `--port` and `--proxy-port`, allocated per app. | Make the embedded Flutter port configurable, and remove or wire up `--web-port`. |
| 7 | Browser-side Dart debugging needs Jaspr to launch Chrome itself, at its internal port. | Serverpod opens the browser at its own URL, as it does for Flutter web. Browser-side debugging is not available. | Allow debugging with an externally opened browser, or accept a launch URL. |

Gaps 1 and 2 decide whether the integration is robust: a developer should never find a stale Jaspr server holding a port after `serverpod start` exits. Gap 3 blocks adopting daemon mode, and gap 4 is the long-term interface question. Gaps 5–7 concern debugging and additional application configurations.

## Serverpod-side work

- **Configuration.** `jaspr_apps` can mirror `tools/serverpod_cli/lib/src/config/flutter_app_config.dart`: app id keys, `path`, `displayName`, `auto_launch`, and non-reserved keys forwarded as CLI arguments. Include the fingerprinting used to detect config changes.
- **Process supervision.**
  - A `JasprAppManager` and `JasprProcess` modeled on `FlutterAppManager` and `FlutterProcess`.
  - Readiness comes from the `[SERVER] Serving at` line or a TCP probe on the assigned port.
  - Stop by signaling the process group, wait, then kill the group.
  - Clean up stale children from a previous crashed session.
  - How to put the child in its own process group from Dart (for example `ProcessStartMode.detachedWithStdio`, or a `setsid` wrapper) and what to do on Windows still need to be validated. A detached child does not report an exit code. Its output streams closing proves neither that it exited nor that its descendants were cleaned up, so detached mode needs a separately validated way to detect termination.
- **TUI.** `AppLogTab` (`tools/serverpod_cli/lib/src/commands/start/tui/tab_model.dart`) is keyed by app id and has run state, URL and a device label, so Jaspr apps fit into the apps area. Map `[TAG]` prefixes and the stdout/stderr split to log levels.
- **Runner API.** `RunnerSnapshot` is Flutter-specific (`flutterApps`, `flutterLines`, `runningFlutterApps`, ...). Its decoder defaults missing fields, so Jaspr fields can be added without breaking `serverpod attach`, MCP or the VS Code extension. The alternative is generalizing to kind-tagged apps.
- **Web server forwarding.**
  - Relic 2 has streaming bodies (`Body.fromDataStream`), `Hijack` and `WebSocketUpgrade`, but no reverse-proxy helper, so Serverpod needs a development forwarding route.
  - The route must set `X-Forwarded-Host` and `X-Forwarded-Proto`.
  - It must forward request bodies, which the live-reload `POST`s need.
  - It must stream responses without buffering, because the live-reload channel is a long-lived event stream.
- **Dev HTML injection.** `WebServer._devHtmlInjection` (`packages/serverpod/lib/src/web_server/web_server.dart:237`) injects Serverpod's `/__dev/version` polling script into HTML responses in dev mode. Forwarded Jaspr responses should be excluded, so pages are not driven by two reload mechanisms.

## Open questions for the spec

### Where SSR runs in production

In the recommended development setup, SSR runs in Jaspr's own process behind Serverpod. The spec records the production setup as an open decision. If production runs Jaspr SSR inside the Serverpod process, development and production diverge: SSR code that uses Serverpod sessions or endpoints in-process would work in production but not in development.

Jaspr's `--skip-server` flag would let Serverpod host the SSR handler itself, with `JASPR_PROXY_PORT` set. Jaspr's server handler already forwards assets and the live-reload stream to the proxy port (`jaspr lib/src/server/server_handler.dart:17`, `:146`). Today it is blocked or unvalidated:

- `jaspr daemon --skip-server` with the default settings renders SSR, but the client never starts. Debugging waits for a Chrome that the `--skip-server` branch never launches, so the counter stayed non-interactive and no `app.started` event arrived.
- Adding `--no-launch-in-chrome` hits the crash in gap 3.
- `jaspr serve --skip-server --verbose` avoids `ClientDomain` and should run `main` normally, but it has not been validated.

Other costs of hosting SSR in Serverpod:

- It needs a shelf-to-Relic adapter, because Jaspr's handler is a shelf `Handler`.
- SSR reloads move from Jaspr's hotreloader to Serverpod's reload workflow.
- The Serverpod server package depends on the Jaspr app package.

With forwarded headers the public origin works in either setup, so the case for this alternative is development/production parity.

### Which routes are forwarded

The spec gives each Jaspr app its own mount point on the Serverpod web server, but how mount points are configured is still open. Mounting the Jaspr app at `/` is straightforward. Mounting it under a path prefix is a separate concern: forwarded host and scheme headers do not cover it, and the Jaspr app's own links and asset URLs need base-path support as well. Only the live-reload channel honors the existing `jaspr_base_path` header.

## Reproduction

From a copy of a server-mode Jaspr app, after `dart pub get`. The `setsid` command is Linux-specific.

```bash
setsid jaspr serve --verbose --port 18080 --proxy-port 15567 \
  < /dev/null > serve.out 2> serve.err &

# Wait until "Serving at" appears in serve.out, then:

# Live-reload endpoint follows the forwarded origin.
curl -s \
  -H 'X-Forwarded-Host: serverpod.example.test:8082' \
  -H 'X-Forwarded-Proto: https' \
  http://localhost:18080/main.client.dart.bootstrap.js | grep dwdsDevHandlerPath

# The live-reload stream stays open, so bound it.
timeout 3 curl -s -N -D - -o /dev/null -H 'accept: text/event-stream' \
  'http://localhost:18080/$dwdsSseHandler?sseClientId=probe'

# Signal the whole process group. The jaspr process owns the proxy port.
JASPR_PID=$(ss -ltnpH 'sport = :15567' | grep -o 'pid=[0-9]*' | cut -d= -f2)
kill -INT -- -"$(ps -o pgid= -p "$JASPR_PID" | tr -d ' ')"
sleep 5   # Shutdown takes a few seconds.
ss -ltn | grep -E ':18080|:15567' || echo 'all ports released'
```

To reproduce the orphaned SSR server, start `jaspr serve` without `setsid`, send `kill -INT` to its pid only, and check that port 18080 is still listening after it exits. Stop the leftover server with `kill $(ss -ltnpH 'sport = :18080' | grep -o 'pid=[0-9]*' | cut -d= -f2)`.
