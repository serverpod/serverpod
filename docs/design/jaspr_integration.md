# Serverpod + Jaspr Development Integration

## Goal

Allow a Serverpod project to use Jaspr for its web frontend while keeping `serverpod start` as the single development entry point.

Developers should not need to run `jaspr serve` separately or manage independent frontend/server processes.

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

Jaspr applications are declared under `jaspr_apps`, following the existing `flutter_apps` convention:

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

`jaspr_apps` is preferred over a generic `web_apps` abstraction because Serverpod is managing a specific development toolchain, just as `flutter_apps` represents applications managed through Flutter.

A broader unified `apps` abstraction may be introduced later if Serverpod gains additional managed application types. It is not required for Jaspr integration.

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

The developer does not need to start, stop, or restart Jaspr independently.

## Development bridge

Jaspr retains its existing development behavior through `jaspr serve`, including:

- SSR
- client compilation
- asset serving
- file watching
- browser refresh

Serverpod exposes each Jaspr application through its own web server and transparently forwards that application's requests to its managed Jaspr development server.

From the browser's perspective, Serverpod remains the application's public entry point, including for Jaspr's automatic browser refresh.

Each exposed Jaspr application needs its own mount point on the Serverpod web server. An application mounted at the root works unchanged. An application mounted under a path prefix must be configured for that base path, because its own links and asset URLs are not rewritten. How mount points are configured is still open.

```text
Browser
   ↓
Serverpod web server
   ↓
Jaspr development server
```

The internal Jaspr development server is an implementation detail and does not need to be accessed directly by the developer.

## Development experience

Changes should preserve the normal expectations of both frameworks:

- Serverpod server changes use Serverpod's normal reload/restart workflow.
- Jaspr changes use Jaspr's normal rebuild and refresh workflow.
- Jaspr assets and SSR remain available through the Serverpod application URL.
- Serverpod manages the lifecycle and development output of all configured applications.
- Jaspr applications appear alongside the Serverpod server and Flutter applications in the `serverpod start` interface.
- Serverpod opens the browser at the Serverpod application URL rather than letting Jaspr launch its own browser.

From the developer's perspective, the project behaves as a single managed development environment.

Two differences from running Jaspr standalone:

- During development, Jaspr's server-side rendering runs in the Jaspr application's own process, not in the Serverpod server. SSR code reaches Serverpod through its API, like any other client.
- Debugging browser-side Dart code, which requires Jaspr to launch and control its own browser, is not part of the integrated workflow.

## Commands

`serverpod start` is the canonical development command.

`jaspr serve` remains the underlying Jaspr development command, but is launched and managed automatically by Serverpod.

Jaspr commands remain available for standalone development and diagnostics when needed. Jaspr's default development port is 8080, the same as Serverpod's default API port, so running `jaspr serve` standalone next to a running Serverpod server requires choosing another port.

## Production

Serverpod remains the deployed server application. How the Jaspr frontend is built and exposed in production is still open.

In development, Jaspr's server-side rendering runs in its own process behind Serverpod. Production can either keep that arrangement, with Serverpod forwarding requests to the built Jaspr server, or run Jaspr's rendering inside the Serverpod server. If production runs it inside Serverpod, development and production behave differently. For example, SSR code that relies on in-process access to Serverpod would work in production but not in development. The choice needs to be made before this part of the experience is specified.

Implementation feasibility and known limitations are tracked in [jaspr_integration_feasibility.md](jaspr_integration_feasibility.md).