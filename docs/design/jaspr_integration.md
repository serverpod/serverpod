# Serverpod + Jaspr Integration

## Goal

Allow a Serverpod project to use Jaspr for its web frontend while keeping `serverpod start` as the single development entry point.

Developers should not need to run `jaspr serve` separately or manage independent frontend/server processes. In production, the built Jaspr applications ship with the Serverpod server, and Serverpod remains the public entry point.

## Project structure

A Serverpod project contains the Jaspr application as a first-class project alongside the server and optional Flutter app:

```text
my_project/
├── my_project_server/
├── my_project_client/
├── my_project_flutter/
└── my_project_web/
    ├── lib/
    │   ├── main.client.dart
    │   └── main.server.dart
    ├── web/
    └── pubspec.yaml
```

The Jaspr application remains an independent Dart package with its normal Jaspr structure. Its Jaspr configuration, such as the rendering mode, stays in the `jaspr:` section of its own `pubspec.yaml`.

## Project configuration

The Jaspr applications that `serverpod start` runs are declared under `jaspr_apps`, following the existing `flutter_apps` convention:

```yaml
serverpod:
  flutter_apps:
    app:
      path: ../my_project_flutter

  jaspr_apps:
    website:
      path: ../my_project_web
      auto_launch: true
```

The second level is an application identifier, allowing multiple Jaspr applications:

```yaml
serverpod:
  jaspr_apps:
    website:
      path: ../my_project_web
      auto_launch: true

    admin:
      path: ../my_project_admin
      auto_launch: false
```

`path` identifies the application package relative to the server package. `auto_launch` controls whether `serverpod start` launches the application on startup. The identifier connects the entry to the application's route in `server.dart`.

`jaspr_apps` only configures development. Where an application is served is defined by its route, which is the same in development and production.

## Serving Jaspr applications

The `serverpod_jaspr` package, added to the server package, provides the route that exposes a Jaspr application on Serverpod's web server. Each application is registered in `server.dart` with its identifier, its rendering mode and the path it is served at:

```dart
import 'package:serverpod_jaspr/serverpod_jaspr.dart';

pod.webServer.addRoute(JasprRoute('website', mode: JasprMode.server), '/');
pod.webServer.addRoute(JasprRoute('admin', mode: JasprMode.client), '/admin/');
```

> An extension method on `Serverpod` can provide a cleaner UX, but this spec shows the route directly for simplicity. Implementation can improve it.

The API names are illustrative. The route behaves the same from the browser's perspective in both environments:

- Under `serverpod start`, it forwards requests to the application's Jaspr development server.
- Otherwise, it serves the application's build output from the server's `web/<app-id>/` directory. In server mode, `serverpod_jaspr` also runs the built Jaspr server. See [Production](#production).

In development, Serverpod verifies and reports in case a route points to:

- An identifier that is not declared in `jaspr_apps`.
- A declared application without a route.
- A route whose mode does not match the application's Jaspr configuration.

The path is the application's mount: `/` for the root application, or a prefix such as `/admin/`. Mounts follow Serverpod's existing route rules. `/admin/` owns its subtree, while `/administrator` belongs to the root application, and more specific Serverpod routes take precedence over an application's catch-all route. Requests to a prefix without its trailing slash redirect to it.

An application mounted at the root works unchanged. An application mounted under a prefix sets that prefix as its own base path: `Document.base` in server and static modes, or `<base href>` in `web/index.html` in client mode. Serverpod does not rewrite links or asset URLs.

**Prefix-mount blocker:** Jaspr 0.23.5 loses the mount prefix from its live-reload URL behind Serverpod. Root mounts work. Prefix mounts, including the `/admin/` example above, remain unsupported until Jaspr preserves the prefix and two mounted applications have been verified to refresh independently through Serverpod.

## Development workflow

The developer runs:

```bash
serverpod start
```

Serverpod manages the complete development environment:

```text
serverpod start
├── Serverpod server
├── database / infrastructure
├── Jaspr applications
└── Flutter applications
```

For each enabled Jaspr application, Serverpod launches and supervises its normal Jaspr development environment.

The developer does not need to run a separate Jaspr command. With `auto_launch: false`, the application stays stopped until launched from its tab in the `serverpod start` interface.

Until an application is ready, its route returns `503 Service Unavailable` naming the application and its state: stopped, starting or failed. A stopped application's page includes a hint to start it from its tab. Requests never launch the application or fall through to another route. The 503 page reloads itself once the application is ready, including across a Serverpod restart. Healthy Jaspr pages use only Jaspr's own refresh.

Like the page Serverpod's Flutter web template serves when the app hasn't been built, the 503 page stands in for the application. Unlike it, the 503 page follows the application's live state and reloads by itself.

## Development bridge

Jaspr retains its existing development behavior through `jaspr serve`, according to the selected rendering mode. For server mode this includes:

- SSR
- client compilation
- asset serving
- file watching
- browser refresh

Serverpod forwards each application's requests, including assets and browser-refresh traffic, from its route to the application's Jaspr development server.

From the browser's perspective, Serverpod remains the application's public entry point, including for Jaspr's automatic browser refresh. Opening the application through a LAN address, a Codespaces URL or a tunnel works the same as through `localhost`.

```text
Browser
   ↓
Serverpod web server
   ↓
Jaspr development server
```

In the default workflow, the internal Jaspr development server is an implementation detail and does not need to be accessed directly by the developer.

> [!NOTE]
> Root-mounted development has been validated in server, static and client modes using a stand-in forwarding proxy. Static and client browser probes verified rendering, interactivity, automatic refresh after an edit, and live-reload GET/POST traffic through the public origin, with no requests to Jaspr's internal ports. Client mode also passed nested-page fallback with a root `<base>`. The actual `serverpod_jaspr` route still needs implementation and the same acceptance tests; prefix mounts remain blocked as described above.

## Development experience

Changes should preserve the normal expectations of both frameworks:

- Serverpod server changes use Serverpod's normal reload/restart workflow.
- Jaspr changes use Jaspr's normal rebuild and refresh workflow.
- Jaspr assets and SSR remain available through the Serverpod application URL.
- Serverpod manages the lifecycle and development output of all configured applications.
- Jaspr applications appear alongside the Serverpod server and Flutter applications in the `serverpod start` interface.
- By default, Serverpod opens the browser at the Serverpod application URL. The optional debugging workflow below lets Jaspr control Chrome.

From the developer's perspective, the project behaves as a single managed development environment.

Browser-side Dart debugging can be provided as an opt-in workflow using `jaspr serve --verbose --launch-in-chrome`. Jaspr owns Chrome and the Dart debug service; Serverpod shows the `[CLIENT]` VM-service URL for debugger attachment and does not open a second browser. With Jaspr 0.23.5, Chrome initially opens the internal Jaspr URL. Navigate that same tab to the public Serverpod application URL, then attach the debugger. A server-mode probe verified a Dart breakpoint and resume through the public forwarding proxy this way.

> [!NOTE]
> Opening directly at the public URL needs an upstream Jaspr launch-URL option. Until then, the navigation step is manual. The ordinary workflow keeps `jaspr serve --verbose` without Chrome control; forwarding alone does not enable Dart debugging in an independently opened browser. Runner/TUI debugger integration and debugging across edits or multiple apps still need validation.

## Commands

`serverpod start` is the canonical development command.

`jaspr serve` remains the underlying Jaspr development command, launched and managed automatically by Serverpod. `jaspr build` produces the production output; see [Production](#production).

Jaspr commands remain available for standalone development and diagnostics when needed. Jaspr's default development port is 8080, the same as Serverpod's default API port, so running `jaspr serve` standalone next to a running Serverpod server requires choosing another port.

## API access and authentication

Jaspr's server-side rendering runs in its own process, in both development and production, and reaches Serverpod through its API like any other client. It cannot rely on in-process Serverpod sessions or endpoint objects.

Serverpod passes the address of its local API listener to the Jaspr server as `SERVERPOD_API_URL`, so SSR calls do not go through the public load balancer. This internal address is server-only: it is never compiled into browser code or rendered into the page.

Components use the project's generated `Client` in both environments, available through Jaspr's component context. During SSR it connects to `SERVERPOD_API_URL`. In the browser it connects to the public API URL and uses the application's authentication provider.

The browser gets the public API URL from `config.json`, as Serverpod's Flutter web apps do. Serverpod serves it below the application's mount, using the API server's public address from its configuration, so one build works in every environment. If it cannot be loaded, the application shows an initialization error with a retry action.

The public API URL must be reachable from the browser. When using LAN devices or tunnels, configure and expose the API server accordingly; exposing the web server alone does not expose the API.

In development, a Jaspr application starts once the Serverpod API is up, whether it launches automatically or from its tab. Jaspr's first build, around 40 seconds, therefore begins after the server has started. If the API address changes, Serverpod restarts the application.

Static generation runs at build time, when no Serverpod API is assumed to be running. Applications that fetch API data while generating must configure an available service for that build.

The initial scaffold makes anonymous SSR API calls. Signed-in content loads after hydration, using the browser's authenticated client. A token stored only in browser storage is not available to SSR. Applications needing authenticated SSR must arrange for credentials to accompany the page request and use a request-scoped client; that flow is outside the initial scaffold.

## Production

Production uses the same routes as development. Build and copy the Jaspr applications using the existing `serverpod.scripts` tooling in the server's `pubspec.yaml`, following the `flutter_build` convention. Define a `jaspr_build` script that runs `jaspr build` in each Jaspr package and places its output in the server's `web/<app-id>/` directory. For example, the POSIX entry for the `website` app is:

```yaml
serverpod:
  scripts:
    jaspr_build:
      posix: |
        set -e

        cd ../my_project_web
        jaspr build

        rm -rf ../my_project_server/web/website
        mkdir -p ../my_project_server/web
        cp -R build/jaspr ../my_project_server/web/website
```

Like `flutter_build`, the script can provide a `windows` entry with the corresponding commands. Maintain these entries when adding applications, and include deployment target flags in each `jaspr build` command where needed. The developer or CI runs the script from the server package before building the server image:

```bash
serverpod run jaspr_build
```

The server template's Dockerfile already copies `web/` into the image, so it needs no Jaspr-specific steps.

| Jaspr mode | Output in `web/<app-id>/` | How the route serves it |
|---|---|---|
| `server` | The `app` executable and its adjacent `web/` assets. | `serverpod_jaspr` runs the executable on an internal port and forwards the application's requests to it. |
| `static` | Pre-rendered pages and assets. | Serves the files, resolving pages such as `/about/` to `about/index.html`. |
| `client` | `index.html` and assets. | Serves the files, falling back to `index.html` for client-side navigation. |

In server mode, the output is a compiled executable for the platform it was built on. Build it for the deployment platform with `--target-os` and `--target-arch`, for example `jaspr build --target-os linux --target-arch x64` on a Mac. Do not serve the whole `web/` directory with a `StaticRoute`, which would make the executable downloadable.

In server mode, `serverpod_jaspr` starts the Jaspr server together with the web server and stops it on shutdown. It runs only in roles that start the web server, so a maintenance run of the same image does not start it. The server reports ready only once the Jaspr server is ready. If the Jaspr server exits unexpectedly, the Serverpod server shuts down with an error so that the deployment platform restarts the instance.

Static and client modes need no Jaspr server process in production.

> [!NOTE]
> The Jaspr server-mode release build has been validated on its own: the copied executable and assets served SSR HTML and compiled JavaScript without Dart or Jaspr on `PATH`. `serverpod_jaspr` is not implemented yet.

Implementation feasibility and known limitations are tracked in [jaspr_integration_feasibility.md](jaspr_integration_feasibility.md).
