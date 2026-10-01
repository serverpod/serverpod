# Serverpod + Jaspr Integration: Feasibility Assessment

## Purpose

Assesses whether the developer experience described in [jaspr_integration.md](jaspr_integration.md) can be built on top of today's Jaspr CLI, with `serverpod start` owning a Jaspr development process, forwarding its output to the TUI, and exposing the Jaspr app through the Serverpod web server.

This is an internal companion to the user-facing spec. It records what was verified, what Serverpod has to build, and what should be raised with the Jaspr maintainers.

## Summary

Root-mounted development is feasible in server, static and client modes by supervising `jaspr serve --verbose`, as long as Serverpod owns shutdown of the whole Jaspr process tree. Browser probes have passed through a stand-in proxy in all three modes; the actual Serverpod route remains to be implemented and tested. Prefix mounts need the additional Jaspr fix described below.

- **Logs:** `--verbose` disables the progress spinner, so piped output is newline-delimited, tagged (`[CLI]`, `[BUILDER]`, `[SERVER]`) and free of ANSI codes. It can be forwarded to the TUI without a machine protocol.
- **Public origin:** for root mounts, when the forwarding route sets `X-Forwarded-Host` and `X-Forwarded-Proto`, Jaspr's live-reload channel uses Serverpod's public origin. The browser never contacts Jaspr's internal ports, and no JavaScript has to be rewritten.
- **Shutdown:** signaling only the `jaspr serve` process orphans its SSR server. A crashed supervisor orphans it too, in every mode tested. Serverpod has to terminate the process tree itself, and a robust fix needs Jaspr changes.
- **Mount prefix:** with forwarded public-origin headers, the live-reload URL loses a configured prefix such as `/admin/`. This was reproduced with both the document base and server handler mounted at that prefix. Prefix mounts remain blocked pending a Jaspr fix and independent multi-app refresh validation.
- **`jaspr daemon`:** the hidden machine mode is not usable as-is. With `--no-launch-in-chrome` it crashes the first time a browser connects. Its default mode launches Jaspr's own Chrome at the internal port instead.
- **Production:** a `serverpod_jaspr` route serves the build output from the server's `web/<app-id>/` directory and, in server mode, runs the compiled Jaspr server. `jaspr build` can cross-compile that server for the deployment platform. Serverpod's existing lifecycle hooks can run it, with two gaps: start hooks are synchronous and run before the API listener binds, and readiness indicators can only be registered at construction.

Running `jaspr serve` as a child keeps the promise of not duplicating Jaspr tooling. Serverpod adds a forwarding route and process supervision; building, SSR, file watching and reload stay in Jaspr.

## Validation

- `jaspr_cli` 0.23.5 and `jaspr` 0.23.5, the latest release at the time of writing (published 2026-09-25).
- Dart SDK 3.12.2, Linux.
- A `jaspr.mode: server` app with `jaspr_router`, run with custom ports so it could not collide with Serverpod defaults. Additional static and client counter-app probes verified root forwarding, interactivity and edit refresh in Chromium. The client fixture included `<base href="/">` and also verified direct navigation to `/nested/page?probe=1` through its SPA fallback. These probes do not validate static/client production routing or prefix mounts.
- Process, port and protocol behavior was probed from the shell.
- Browser behavior was validated separately in an isolated Chromium, both directly and through a small HTTP forwarding proxy that stands in for a Serverpod route. No Serverpod route has been implemented.
- A separate prefix probe mounted a server-mode app at `/admin/`, set `Document(base: '/admin/')`, and inspected the bootstrap with and without forwarded headers. It did not validate browser refresh under that prefix.
- `jaspr build --verbose` succeeded for a server-mode app. Its executable and adjacent assets were copied to a separate directory and served SSR HTML and compiled JavaScript with neither Dart nor Jaspr on `PATH`. This validates the Jaspr release artifact, not a Serverpod deployment image.

## Recommended mechanism

The following command and forwarding path were validated for server and static modes:

```bash
jaspr serve --verbose --port <ssr-port> --proxy-port <proxy-port>
```

- Serverpod allocates `--port` and `--proxy-port` per server/static app. In client mode, Jaspr puts its development proxy on `--port` and does not start an SSR server; the forwarding target is that port (`dev_command.dart:110-140`).
- In server mode, the forwarding route sends requests to `<ssr-port>` with `X-Forwarded-Host` and `X-Forwarded-Proto` derived from the incoming request's effective public origin, and streams responses. Honor upstream forwarded headers from trusted proxies; do not substitute the configured browser-launch URL.
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

### Static and client development

Both modes were exercised with Jaspr 0.23.5 and Dart 3.12.2 in isolated Chromium through the same streaming, forwarded-header proxy used for the server-mode probe. [Jaspr's CLI documentation](https://docs.jaspr.site/dev/cli) describes static development as on-demand SSR, while client development serves compiled browser code directly; the probes exercised both paths.

| Check | Static | Client |
|---|---|---|
| Page renders and counter responds to a click | Passed | Passed |
| Editing the counter's Dart source refreshes the page automatically | Passed | Passed |
| Live-reload GET and POST use the public proxy and return 200 | Passed | Passed |
| Browser requests to either internal Jaspr port | None | None |
| Direct nested-page navigation with a root `<base>` | Not exercised | Passed |

Client mode served from `--port` and logged `[CLI] Serving at`; it did not need an SSR process. The client fixture sets `<base href="/">`, since the generated client template uses relative asset URLs without a base and would otherwise resolve them below a nested page. The temporary probe is `/tmp/jaspr_mode_validation.py`; results are `/tmp/jaspr-mode-validation/{static,client}.json`. These are local evidence artifacts, not a checked-in integration suite. Repeat these checks against the actual `JasprRoute` before declaring integrated support.

### Browser-side Dart debugging

Debugging through a public forwarding origin is possible with today's `jaspr serve --verbose --launch-in-chrome`, provided the tab belongs to the Chrome instance Jaspr controls. `ServeCommand` then registers `ClientDomain` and prints the client VM-service URL (`jaspr_cli lib/src/commands/serve_command.dart:34-40`, `:55-58`). DWDS receives that Chrome connection from `DevProxy` (`lib/src/dev/dev_proxy.dart:126`). Without the flag, the debug service and extension support are disabled; forwarding alone cannot attach an arbitrary external browser.

The server-mode probe let Jaspr launch Chrome at its internal URL, waited for client startup, and navigated that same tab to the public proxy URL. It connected to the reported client VM service, set a breakpoint at `count++` in the original Dart counter source, observed `PauseBreakpoint`, resumed, and verified the updated counter in the browser. Live-reload GET/POST requests used the public proxy. The probe used a `CHROME_EXECUTABLE` wrapper only to add headless/test flags to an isolated Chromium; it did not modify Jaspr or replace the launch URL. Local artifacts: `/tmp/jaspr_debug_validation.py` and `/tmp/jaspr-mode-validation/debug.json`.

The optional integrated workflow therefore lets Jaspr own Chrome, surfaces the `[CLIENT]` debug-service URL in the app tab, and suppresses Serverpod's separate browser launch. The developer navigates Jaspr's tab to the public application URL before attaching a Dart debugger. This is a verified manual workaround, not a fully integrated debugger implementation. Breakpoint preservation across rebuilds, static/client debugging and simultaneous debug sessions for multiple apps remain untested.

For automatic navigation, request a Jaspr launch-URL option: `_runChrome()` passes only the internal port to `startChrome`, which constructs `http://localhost:<port>` (`lib/src/commands/dev_command.dart:264`, `lib/src/dev/chrome.dart:15-16`). Serverpod would supply the registered route's public URL while Jaspr retains ownership of Chrome and DWDS. That CLI option does not exist in 0.23.5. Keep the ordinary no-Chrome workflow as the default; no daemon adoption is needed for this debugging path.

### Public origin through a forwarding proxy

dwds builds the live-reload endpoint from `request.requestedUri` (`dwds lib/src/handlers/injector.dart:71-87`). dart:io reconstructs `requestedUri` from `X-Forwarded-Host` and `X-Forwarded-Proto`. Jaspr's SSR server forwards request headers to its proxy, so the headers set by Serverpod reach dwds:

```text
GET /main.client.dart.bootstrap.js
  X-Forwarded-Host: serverpod.example.test:8082
  X-Forwarded-Proto: https

window.$dwdsDevHandlerPath = "https://serverpod.example.test:8082/$dwdsSseHandler";
```

Jaspr's own bootstrap rewrite (`jaspr_cli lib/src/helpers/proxy_helper.dart:63`) only replaces `http://localhost:<proxy-port>/`, so it leaves a forwarded origin alone.

The route must derive those header values per request, retaining any public port and honoring trusted upstream forwarding. The configured public URL is only the TUI/browser-launch default. A request made through a LAN address or tunnel must retain that origin even if configuration says `localhost:8082`. This request-origin policy also applies in production. The fixed header values in the probe demonstrate how Jaspr handles them; they are not a proposed fixed-origin configuration.

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
| 7 | Debugging launches Jaspr's controlled Chrome at its internal URL. | Opt in to `serve --launch-in-chrome`, navigate that tab to the public URL, and attach to the reported client VM service. A Dart breakpoint/resume passed through the proxy. | Accept a public launch URL so the navigation step can be automatic. |
| 8 | The live-reload URL loses the mount prefix when forwarded public-origin headers are present. | Keep prefix mounts unsupported until fixed; root mounts retain the validated behavior. | Preserve both the forwarded origin and the server handler's mount prefix when constructing the DWDS endpoint. |

Gaps 1 and 2 decide whether the integration is robust: a developer should never find a stale Jaspr server holding a port after `serverpod start` exits. Gap 3 blocks adopting daemon mode, and gap 4 is the long-term interface question. Gaps 5–7 concern debugging and additional application configurations. Gap 8 blocks prefix mounts, including the spec's `/admin/` example.

## Serverpod-side work

- **Configuration.** `jaspr_apps` can mirror `tools/serverpod_cli/lib/src/config/flutter_app_config.dart`: app id keys, `path`, `displayName`, `auto_launch`, and non-reserved keys forwarded as CLI arguments. Include the fingerprinting used to detect config changes. The runner reads each app's rendering mode from `jaspr.mode` in its pubspec. Mounts are not part of `jaspr_apps`; they are the route paths in `server.dart`.
- **Process supervision.**
  - A `JasprAppManager` and `JasprProcess` modeled on `FlutterAppManager` and `FlutterProcess`.
  - Reuse Flutter's first-UI-attachment auto-launch trigger and `WatchSession` queue. Extend the launch gate to require Jaspr's bound internal API address; manual launches use the same queue and address requirement. Do not add a separate launch path before server compilation/startup.
  - Readiness must probe the assigned upstream and account for the mode. Server/static modes log `[SERVER] Serving at`; client mode logs `[CLI] Serving at` and has no SSR child. All three root forwarding paths passed the stand-in proxy probe; the manager and actual route remain to be tested together.
  - With `auto_launch: false`, do not start Jaspr until the user launches it from the TUI. The route returns a state-appropriate 503 meanwhile. Do not launch on incoming requests.
  - Stop by signaling the process group, wait, then kill the group.
  - Clean up stale children from a previous crashed session.
  - How to put the child in its own process group from Dart (for example `ProcessStartMode.detachedWithStdio`, or a `setsid` wrapper) and what to do on Windows still need to be validated. A detached child does not report an exit code. Its output streams closing proves neither that it exited nor that its descendants were cleaned up, so detached mode needs a separately validated way to detect termination.
- **TUI.** `AppLogTab` (`tools/serverpod_cli/lib/src/commands/start/tui/tab_model.dart`) is keyed by app id and has run state, URL and a device label, so Jaspr apps fit into the apps area. Map `[TAG]` prefixes and the stdout/stderr split to log levels. When browser debugging is opted into, pass `--launch-in-chrome`, show the `[CLIENT]` debug-service URL separately from the SSR service, and let Jaspr own Chrome instead of opening a second browser. Keep the public application URL visible for the manual navigation step.
- **Runner API.** `RunnerSnapshot` is Flutter-specific (`flutterApps`, `flutterLines`, `runningFlutterApps`, ...). Its decoder defaults missing fields, so Jaspr fields can be added without breaking `serverpod attach`, MCP or the VS Code extension. The alternative is generalizing to kind-tagged apps.
- **Runner-to-server state.** Allocate app ports once per runner session, pass each app's id, mode and upstream URL through `ServerProcess.environment`, and publish live states through a development-only `ext.serverpod.setJasprAppStates` service extension. Replay the complete snapshot after every server restart or reconnection; details below.
- **`serverpod_jaspr` package.** A package added to the server package, so Serverpod core only gains what the package cannot do on its own.
  - `JasprRoute` forwards to the development server when the runner's app data is present. Otherwise it serves `web/<app-id>/` according to its declared mode, or returns a 503 explaining how to start the app when there is no build output, for example when the server is launched from an IDE outside `serverpod start`.
  - In development, the server compares its Jaspr routes with the runner's app data and reports undeclared ids, declared apps without a route, and a route mode that differs from the app's `jaspr.mode`.
  - Static mode: Relic's static handler returns 404 for a directory instead of serving its `index.html` (`relic_io lib/src/io/static/static_handler.dart:230-231`), while Jaspr writes extensionless generated routes to `<route>/index.html` (`jaspr_cli lib/src/commands/build_command.dart:327-336`). The route needs index-file resolution; missing pages keep a 404.
  - Client mode: Serverpod's `SpaRoute` (`packages/serverpod/lib/src/web_server/routes/spa_route.dart`) already provides the `index.html` fallback.
  - Server mode: runs the compiled Jaspr server; see [Running the Jaspr server](#running-the-jaspr-server).
  - Serve `config.json` below each mount in both environments, with `{"apiUrl": "<resolved-public-api-url>"}` and `Cache-Control: no-store`. This reserved path takes precedence over static files, SPA fallback and forwarding. Reuse the existing `AppConfigRoute` JSON contract; no HTML rewriting is needed for API configuration.
  - Reserve `__serverpod/status` below each mount in development. It takes precedence over the app's catch-all and over forwarding.
- **Web server forwarding.**
  - Relic 2 has streaming bodies (`Body.fromDataStream`), `Hijack` and `WebSocketUpgrade`, but no reverse-proxy helper, so `serverpod_jaspr` needs its own forwarding.
  - The route must set `X-Forwarded-Host` and `X-Forwarded-Proto` from the incoming request, honoring trusted upstream forwarded headers and preserving the public port. The configured browser-launch URL must not override them.
  - Preserve the prefix for a mounted server/static development handler. Strip it for the root-based client-mode proxy, retaining the query string in both cases. Client-mode reload must still advertise the public prefix; stripping alone does not solve gap 8.
  - It must forward request bodies, which the live-reload `POST`s need.
  - It must stream responses without buffering, because the live-reload channel is a long-lived event stream.
- **Development recovery page.** `WebServer._devHtmlInjection` (`packages/serverpod/lib/src/web_server/web_server.dart:237`) only injects the existing `/__dev/version` polling script into HTML 200 responses, so a 503 does not gain recovery automatically. Explicitly embed a polling script in the route's HTML 503 page. It polls `GET __serverpod/status` below the app's mount every 500 ms and reloads when the synchronized app state is `ready`, even on the first poll. Failed requests keep polling across a server restart. Use the same polling pattern as `devAutoRefreshScript`, with app readiness as the condition; the existing global static-file counter does not represent per-app state. Exclude healthy forwarded Jaspr responses from Serverpod's refresh-script injection so they use only Jaspr refresh.
- **API clients.** Reuse the project's generated `Client` in both environments. SSR uses the runtime variable `SERVERPOD_API_URL`; browser initialization fetches the mount's `config.json` before constructing the client. Make the client available through Jaspr component context. The initial scaffold uses anonymous SSR calls; authenticated SSR needs an application-owned request credential bridge and request-scoped clients.

### Development registration and state synchronization

`ServerProcess` already accepts an environment map and supports VM-service calls (`tools/serverpod_cli/lib/src/commands/start/server_process.dart:72-84`, `:142`, `:271`). The detached runner, not the attached TUI, owns the proposed Jaspr manager and this state channel.

1. Allocate upstream ports once per runner session, including stopped apps. Pass `SERVERPOD_JASPR_APPS` as JSON containing a session id and each app's identifier, mode and loopback upstream URL to every Serverpod process. Routes in `server.dart` look up their app by identifier. Keep assignments stable across server and Jaspr restarts. Changes to the app set restart the Serverpod child with fresh startup data.
2. Register a development-only `ext.serverpod.setJasprAppStates` VM-service extension. The runner sends a complete snapshot with the session id, a monotonically increasing revision and each app's state (`stopped`, `starting`, `ready`, or `failed`). The server validates app ids against startup data, rejects older revisions or a different session, updates its registry and acknowledges the applied revision. Replaying the same revision is idempotent and returns the acknowledgement again. The runner marks `ready` only after both API startup and its upstream readiness probe succeed. Reset readiness across API restarts and restart Jaspr if its internal API address changes.
3. Enable the VM service for managed Jaspr development even if file watching is disabled. On a new server process or connection, wait for extension registration and resend the latest complete snapshot; retry until acknowledged. A replacement server begins unsynchronized and returns a generic unavailable 503 until replay, rather than guessing a state from an open port. A missing extension must surface as a runner/server version error.
4. Forwarding routes read this registry. An unreachable upstream despite a `ready` snapshot returns a generic unavailable 503. `GET __serverpod/status` below the app's mount reads the same registry, returns its current state with no caching, and is available only in development. The recovery page polls for current readiness, avoiding a missed-change race between rendering the 503 and its first poll.

`ext.serverpod.addresses` is an existing server-to-runner extension event, not a callable RPC. Its `api` field describes the public URL (`packages/serverpod_shared/lib/src/serverpod_addresses.dart`). Extend that publication with a separate `internalApi` field derived from the bound local listener, for the runner's `SERVERPOD_API_URL` handoff. Do not use the public field for SSR. Address publication must precede waiting for Jaspr readiness, so the two processes do not wait on each other. State synchronization uses the new RPC in the opposite direction. In production, `serverpod_jaspr` runs inside the server process, reads the bound API port directly and supervises its own child, so it needs no VM service.

This environment schema, address-event addition, service extension, status endpoint and replay behavior are proposed implementation work. Acceptance tests must cover stopped-to-ready recovery, ready-before-first-poll, delayed extension registration, independent server restarts, stale revisions and two apps changing state independently.

## Production

The spec keeps SSR in a separate process in both development and production. Production uses the same `server.dart` routes as development. The existing `serverpod run` script runner invokes Jaspr's build and copies its output.

### Build output and packaging

Define `serverpod.scripts.jaspr_build` in the server's `pubspec.yaml`, following the existing `flutter_build` script (`templates/serverpod_templates/projectname_server/pubspec.yaml:26`). The script runs `jaspr build` in each Jaspr package and copies `build/jaspr/` to the server's `web/<app-id>/`. The developer or CI invokes it with `serverpod run jaspr_build` before building the server image.

`RunCommand` already reads these scripts, executes them with the server package as the working directory, and propagates a failing exit code (`tools/serverpod_cli/lib/src/commands/run.dart`). The script format supports `posix` and `windows` entries, as used by `flutter_build`. Keep app paths, output destinations and deployment target flags in the build script, and stop on a failed build or copy. Existing projects add or update the entry when adopting Jaspr; the runner does not derive build commands from the development-only `jaspr_apps` configuration. The spec's POSIX example uses `set -e` for failure propagation. This reuses existing script tooling; the Jaspr-specific script has not been validated on Windows.

- The template Dockerfile copies the whole server package into its build stage and `web/` into the final image (`templates/serverpod_templates/projectname_server/Dockerfile:10`, `:46`). The template has no `.dockerignore`, so the build output reaches the image without Dockerfile changes.
- **Server mode:** `jaspr build` compiles `app` with release flags, with assets in an adjacent `web/` (`jaspr_cli lib/src/commands/build_command.dart:136-137`, `:208-223`). Compiled Jaspr resolves assets relative to the executable (`jaspr lib/src/server/server_handler.dart:20-27`), so both stay together under `web/<app-id>/`.
- `jaspr build` accepts `--target-os` and `--target-arch` for the `exe` and `aot-snapshot` targets (`build_command.dart:44-49`, `:186-201`), so the executable can be cross-compiled for the image. The final image is Alpine with the Dart runtime libraries copied in (`Dockerfile:29`, `:39`), as for the Serverpod executable. A cross-compiled Jaspr executable has not been run there.
- A `StaticRoute.directory` over all of `web/` would serve the executable. The template registers no web routes, but projects that add such a route must exclude `web/<app-id>/`.
- Static and client output only need the file-serving behavior described under [Serverpod-side work](#serverpod-side-work).

### Running the Jaspr server

In server mode, `serverpod_jaspr` runs the executable within the Serverpod process's lifecycle. Existing hooks cover most of it:

- `pod.experimental.registerStartHook` (`packages/serverpod/lib/src/server/serverpod.dart:1594`) can start the child. The hook is synchronous and experimental. It runs again after every hot reload (`:1662`, `packages/serverpod/lib/src/server/server.dart:140`), and it runs before the servers start (`serverpod.dart:793`, servers at `:886`). The package must start the child at most once, and wait for the API listener to bind before launching it with `PORT` and `SERVERPOD_API_URL`.
- `pod.experimental.shutdownTasks` (`serverpod.dart:1611`) can stop the child. Shutdown tasks run after the API, web and Insights servers close.
- Start the child only in roles that start the web server: `monolith` or `serverless`, with the web server enabled (`serverpod.dart:862-863`, `_startUserFacingServers`). A `maintenance` run of the same image then does not start Jaspr.
- `/readyz` indicators are only taken from `HealthConfig` at construction (`packages/serverpod/lib/src/server/health/health_check_service.dart:42-46`). Either the developer adds the package's indicator to `HealthConfig`, or Serverpod adds a way to register indicators later.
- If the child exits unexpectedly, shut the pod down with an error so the deployment platform restarts the instance. In a container, the child ends with the container, so orphaned Jaspr servers are mainly a development concern.

None of this is implemented. The release-build probe validated the executable on its own, not inside a Serverpod image or under `serverpod_jaspr`.

## SSR API address and authentication

The integration passes `SERVERPOD_API_URL` as a runtime environment variable to the Jaspr server in both development and server-mode production. It identifies the local Serverpod API listener, normally `http://127.0.0.1:<bound-api-port>/`, using its actual transport and bound port rather than `publicHost`/`publicPort`. SSR uses the existing generated `Client` at this address. In development, the runner waits for the proposed `internalApi` field in `ext.serverpod.addresses` for both fixed and ephemeral ports. Reconcile the address on every server startup and restart Jaspr if it changes. In production, `serverpod_jaspr` reads the bound API port in-process and passes it to the executable. Jaspr passes the parent environment to the SSR process (`jaspr_cli lib/src/process_runner.dart`, `includeParentEnvironment: true`), and `dev_command.dart:173-181` forwards Dart defines as `-D` flags. These source checks support the environment handoff, but not the full Serverpod integration.

Reuse Flutter's existing launch path. The runner creates `FlutterAppManager` with `autoLaunchArmed: false` (`tools/serverpod_cli/lib/src/commands/start.dart:1202`), boots the initial server, and installs `launchAppsIfReady` after session setup (`:1409-1433`). That gate waits for the first UI attachment and, when the API port was overridden, the reported API URL. It calls `WatchSession.launchAutoLaunchApps()`, which queues launch behind in-flight session work (`tools/serverpod_cli/lib/src/commands/start/watch_session.dart:717-724`). Flutter does not wait for an address event on an unchanged configured port, but it also does not launch alongside the initial server compilation. The gate is only installed when the `--flutter` flag is on (`start.dart:1429`), and the flag's help text describes it as Flutter-only (`tools/serverpod_cli/lib/src/commands/runner_options.dart:26-30`). Decide whether `--no-flutter` also suppresses Jaspr auto-launch, or whether the flag is renamed or split.

Extend that trigger and session queue to launch Jaspr apps, requiring the published internal API address before their processes start. Apply the same address requirement to manual launches. Jaspr's roughly 40-second first build therefore starts after API address publication and UI attachment for auto-launched apps; there is no special fixed-port path or early parallel launch. Until its upstream probe succeeds, the route returns the existing starting/unavailable 503. Listener binding/address publication must not wait for Jaspr readiness. Acceptance tests must cover UI attachment before and after address publication, fixed and ephemeral ports, API startup failure, launch requests during a reload, and a changed address after restart. Reusing the Flutter launch path is the design decision; the Jaspr manager and its integration into that path remain unimplemented.

For browsers, reuse the existing `config.json` approach. Serverpod's template `AppConfigRoute` emits `{"apiUrl": ...}` from the public API configuration (`templates/serverpod_templates/projectname_server_upgrade/lib/src/{{#webserver}}web{{!webserver}}/routes/{{#webapp}}app_config_route{{!webapp}}.dart`). The generated `Client` accepts a URL; it does not discover configuration itself (`packages/serverpod_client/lib/src/serverpod_client_shared.dart:152`). `getServerUrl()` supplies that URL for Flutter but imports `package:flutter/services.dart` and reads `rootBundle`, so Jaspr cannot reuse that helper unchanged (`packages/serverpod_flutter/lib/src/get_server_url.dart`). No replacement API client is required.

Each `JasprRoute` serves `config.json` below its mount, ahead of forwarding, files and SPA fallback, with `Cache-Control: no-store`. It computes `apiUrl` from the resolved public API configuration at request time in all modes and environments. The browser scaffold resolves that path against `document.baseURI`, fetches and validates it once before `runApp`, then constructs the generated `Client` with the application's authentication provider. Client-mode scaffolds set `<base href="/">` even at the root so nested navigation resolves configuration and assets correctly. Failed loads surface an initialization error with retry, not a silent localhost fallback. The extra initialization request avoids HTML buffering/rewriting and its encoding/cache concerns.

The server entrypoint uses a request-scoped generated `Client` with `SERVERPOD_API_URL`; the browser entrypoint uses the asynchronously loaded public URL. Both expose the same client type through normal Jaspr component context. Platform-specific initialization stays in the respective entrypoints or conditional imports. Client instances and internal URLs are never serialized as hydration data. The JSON contains neither the internal URL nor credentials. LAN/tunnel deployments must configure and expose a browser-reachable API; exposing only the web server is insufficient. This loader and route wiring still need implementation and end-to-end validation.

Static generation at build time does not imply that a Serverpod API is running; any API data source needed during generation must be configured explicitly for that build. The internal-address handoff and static build-time fetching have not been exercised here.

The initial scaffold performs anonymous SSR calls and loads signed-in content after browser hydration. No automatic authentication-cookie bridge is included. The generated client sends credentials supplied by its `authKeyProvider` (`packages/serverpod_client/lib/src/serverpod_client_shared.dart`); it cannot recover a browser-storage token from an ordinary page request. Application-specific authenticated SSR requires credentials on the incoming request and a request-scoped client, without changing shared-client credentials. That flow remains outside the scaffold and unvalidated.

## In-process SSR alternative

Hosting SSR inside Serverpod is not the selected design. It would require changing development as well to preserve parity; otherwise SSR code using Serverpod sessions or endpoints in-process would work only in production.

Jaspr's `--skip-server` flag would let Serverpod host the SSR handler itself, with `JASPR_PROXY_PORT` set. Jaspr's server handler already forwards assets and the live-reload stream to the proxy port (`jaspr lib/src/server/server_handler.dart:17`, `:146`). Today it is blocked or unvalidated:

- `jaspr daemon --skip-server` with the default settings renders SSR, but the client never starts. Debugging waits for a Chrome that the `--skip-server` branch never launches, so the counter stayed non-interactive and no `app.started` event arrived.
- Adding `--no-launch-in-chrome` hits the crash in gap 3.
- `jaspr serve --skip-server --verbose` avoids `ClientDomain` and should run `main` normally, but it has not been validated.

Other costs of hosting SSR in Serverpod:

- It needs a shelf-to-Relic adapter, because Jaspr's handler is a shelf `Handler`.
- SSR reloads move from Jaspr's hotreloader to Serverpod's reload workflow.
- The Serverpod server package depends on the Jaspr app package.

The selected design preserves the same process boundary in both environments without depending on this alternative or on `--skip-server`.

## Mount contract and confirmed prefix blocker

Each app's mount is the path of its route in `server.dart`, used in both development and production. Mounts follow Serverpod's existing route specificity and conflict rules. Prefixes match path segments: `/admin/` owns that subtree, while `/administrator` remains with the root app. The document base and, where applicable, the server-side routing context must agree with the mount; app links and asset URLs are not rewritten.

Because the mount is defined in the server, the runner does not know it, and each app configures its own base path. If prefix mounts become supported, the server could publish its mounts to the runner, which would pass them to Jaspr as a Dart define; both `serve` and `build` accept `--dart-define` (`jaspr_cli lib/src/helpers/dart_define_helpers.dart`).

- **Server/static modes:** the app sets `Document.base` to the mount. Jaspr's server rendering derives its routing base from the shelf request's `handlerPath` (`jaspr lib/src/server/render_functions.dart:27-30`), so mount the handler too and preserve the prefix when forwarding. This also applies to server-mode production. Stripping the prefix before forwarding to an unchanged root handler loses that routing context.
- **Client development:** the developer keeps the static `web/index.html` `<base>` in sync with the mount, following [Jaspr's client-mode base setup](https://docs.jaspr.site/dev/deploying). Defines cannot modify HTML before its script loads. Jaspr serves this mode directly through its root-based dev proxy, with fallback to `/` for unknown extensionless paths (`dev_command.dart:110-140`, `proxy_helper.dart:82-92`), so strip the mount prefix before forwarding. Root forwarding and nested-page fallback with `<base href="/">` passed the browser probe. The public refresh endpoint still needs any mount prefix, and the prefixed flow remains blocked and untested.
- **Static production generation:** Jaspr starts a temporary server, requests `/` initially and generates app-relative routes. A development handler mounted only at `/admin/` cannot simply be reused unchanged for that build. The scaffold must preserve the public base in generated HTML and links while supporting app-relative generation and output paths. This mode and its mounted build behavior remain unvalidated.

All three modes passed root development probes through a stand-in forwarding proxy. Static/client production routing and the real Serverpod route still need separate acceptance tests; development evidence does not establish that support.

In the prefix probe, the app had `Document(base: '/admin/')` and middleware that mounted its handler using `request.change(path: 'admin/')`. Requesting `/admin/main.client.dart.bootstrap.js` produced:

```text
Without forwarded headers:
window.$dwdsDevHandlerPath = "http://localhost:38480/admin/$dwdsSseHandler";

With X-Forwarded-Host: serverpod.example.test:8082
and X-Forwarded-Proto: https:
window.$dwdsDevHandlerPath = "https://serverpod.example.test:8082/$dwdsSseHandler";
```

The second URL is missing `/admin/`. Jaspr's bootstrap rewrite uses `jaspr_base_path`, but only when replacing `http://localhost:<proxy-port>/` (`jaspr_cli lib/src/helpers/proxy_helper.dart:58-63`). Once DWDS emits the forwarded public origin, that replacement does not run. This is separate from public-origin support, which works for root mounts.

Prefix support requires Jaspr to preserve both origin and prefix. Before enabling it, verify two mounted apps through a real Serverpod route: nested-page requests, links, assets, and each app's live-reload GET/POST traffic must reach the correct app, and edits must refresh the apps independently. The mount contract is decided; this acceptance gate remains open.

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
