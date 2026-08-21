# Flutter apps launched by `serverpod start`

Reference for the [Serverpod Configuration](../SKILL.md) skill.

Companion Flutter apps that `serverpod start` can launch (Ctrl+R) are declared
in the server `pubspec.yaml` under `serverpod: flutter_apps:`, a map of display
alias to properties (alongside `serverpod: scripts:`):

- `path`: path to the Flutter package, relative to the server package.
- `displayName`: optional human-readable label for TUI tab names. When omitted,
  the app id is used.
- `auto_launch`: launch this app automatically on `serverpod start`. Apps
  without it are launched on demand with `Ctrl+R`.
- `device`: the `flutter run -d` target. Defaults to the web server (opening a
  browser when ready) when omitted.

**Any other property** is forwarded to `flutter run`: `target: lib/main.dart`
becomes `--target=lib/main.dart`, `release: true` becomes `--release`,
`release: false` becomes `--no-release`, and a list value repeats the flag
(`dart-define: [A=1, B=2]` becomes `--dart-define=A=1 --dart-define=B=2`).

When the key is absent, the sibling `../<project>_flutter` package is used
automatically (and auto-launched) if present.

```yaml
serverpod:
  flutter_apps:
    Admin:
      path: ../apps/admin
      displayName: "Admin app"
      auto_launch: true
      device: chrome
      target: lib/main.dart
    Portal:
      path: ../apps/portal
```
