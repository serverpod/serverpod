# Serverpod + Jaspr Integration: Requests for Jaspr

Serverpod plans to run `jaspr serve --verbose` under `serverpod start` and forward the application's traffic through Serverpod's web server, so the browser only talks to Serverpod. In production, Serverpod serves the `jaspr build` output and runs the server-mode executable. See the [spec](jaspr_integration.md) for the design and the [feasibility assessment](jaspr_integration_feasibility.md) for the evidence.

Observed with `jaspr_cli` and `jaspr` 0.23.5 on Dart 3.12.2, Linux. Source references are to `jaspr_cli` unless noted.

## Blocking

1. **Keep the mount prefix in the live-reload URL behind a proxy.**
   With `X-Forwarded-Host` and `X-Forwarded-Proto` set and the application mounted at `/admin/`, the bootstrap emits `https://<public-host>/$dwdsSseHandler`, without `/admin/`. The `jaspr_base_path` rewrite only replaces `http://localhost:<port>/` (`lib/src/helpers/proxy_helper.dart:58-63`), so it no longer applies once DWDS uses the forwarded origin.
   **Ask:** build the live-reload endpoint from both the forwarded origin and the mount prefix.
   This blocks serving a Jaspr application below a path prefix, and so running more than one application behind the same server.

## Robustness

2. **Stop the SSR server when `jaspr serve` is signaled.**
   SIGINT or SIGTERM to the `jaspr serve` process alone exits the CLI but leaves the SSR server running and bound to its port. Ctrl+C in a terminal hides this because it signals the whole process group.
   **Ask:** terminate the SSR server before `jaspr serve` exits.

3. **Don't outlive the supervisor.**
   If the supervising process dies, the SSR server keeps running. `.dart_tool/jaspr/server.pid` is created and truncated but never written (`lib/src/commands/dev_command.dart:167-171`).
   **Ask:** exit when the parent goes away, for example when stdin closes, and write the SSR server's pid to `server.pid`.

## Debugging

4. **Launch URL for `--launch-in-chrome`.**
   Jaspr always opens `http://localhost:<port>` (`dev_command.dart:264`, `lib/src/dev/chrome.dart:15-16`). Behind Serverpod, the developer has to navigate that tab to the public URL before attaching a debugger.
   **Ask:** an option for the URL Chrome opens, with Jaspr still owning Chrome and the debug service.

5. **Ephemeral VM service port for the SSR server.**
   The SSR server uses `--enable-vm-service` on the default port 8181 (`dev_command.dart:179`). A second application logs `[SERVER] [ERROR] Could not start the VM service` and loses its SSR debugger.
   **Ask:** use `--enable-vm-service=0`.

## Multiple applications

6. **Configurable ports.**
   Embedded Flutter mode hardcodes port 5678 (`lib/src/project.dart:298`), so two `jaspr.flutter: embedded` applications cannot run together. `--web-port` is declared but never read (`dev_command.dart:50`).
   **Ask:** make the embedded Flutter port configurable, and wire up or remove `--web-port`.

## Longer term

7. **A supported machine-readable interface.**
   Serverpod parses the `--verbose` text: the `[CLI]`, `[BUILDER]` and `[SERVER]` prefixes and the `Serving at` lines. `jaspr daemon` is the closest fit, but it is hidden, its `daemon.log` events carry pre-rendered strings with color codes, and `--no-launch-in-chrome` crashes on the first browser connection with `Bad state: Main has already started.` because `main` runs from both `lib/src/dev/dev_proxy.dart:34` and `lib/src/dev/client_domain.dart:221`.
   **Ask:** a documented mode, such as `jaspr serve --machine` or a supported daemon, with structured tag and level fields and build started, succeeded and failed events. Fix the daemon's double `main`. Until then, keep the `--verbose` tags and `Serving at` lines stable.

## Behavior we rely on

These already work. Please keep them covered:

- The live-reload URL follows `X-Forwarded-Host` and `X-Forwarded-Proto`, so root-mounted applications refresh through the public origin.
- Piped `--verbose` output is newline-delimited, tagged and free of ANSI codes.
- `--port` and `--proxy-port` cover every port Serverpod allocates per application.
- The SSR server inherits the environment of `jaspr serve`, which carries `SERVERPOD_API_URL`.
- `jaspr build --target-os` and `--target-arch` cross-compile the server-mode executable.
