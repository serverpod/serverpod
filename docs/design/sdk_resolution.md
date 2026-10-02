# Design: Dart and Flutter SDK resolution

This document describes how the Serverpod CLI decides which Dart and Flutter
SDK to use when it runs `pub get`, `flutter create`, `flutter run`, and when it
compiles and runs the server. Today that decision is made independently at
different call sites using two different and sometimes conflicting strategies.
This proposes a single resolution chain — **`SdkResolver`** — that every call
site consults, and which follows the SDK a version manager picks for the
project.

The user-visible goal: a developer who pins Flutter with a version manager
should be able to run `serverpod create` and `serverpod start` and have them
work, with the project's pinned SDK. For fvm this takes a one-time setup (see [fvm](#fvm)).

## Current state

The CLI resolves Dart and Flutter in two unrelated ways.

**By PATH lookup** — the bare names `dart` and `flutter`, resolved by the OS
against `$PATH`:

- `tools/serverpod_cli/lib/src/runner/serverpod_command_runner.dart` —
  `_preCommandEnvironmentChecks` runs `dart --version` and `flutter --version`
  before *every* command and aborts the CLI if either is missing. The Flutter
  check is skipped when `ci.isCI`.
- `tools/serverpod_cli/lib/src/util/command_line_tools.dart` — the
  `existsCommand('flutter')` probe that chooses between `flutter pub get` and
  `dart pub get`, plus `dartPubGet`, `flutterPubGet`, and `flutterCreate`.
- `tools/serverpod_cli/lib/src/commands/start/flutter_app_manager.dart` passes
  the literal `'flutter'` to `FlutterProcess`.

**By the CLI's own SDK** — `getSdkPath()` from `cli_util`, which is just
`dirname(dirname(Platform.resolvedExecutable))`, i.e. the SDK of the Dart VM
that is running the CLI:

- `tools/serverpod_cli/lib/src/commands/start/kernel_compiler.dart` — the
  Frontend Server `sdkRoot`, the `vm_platform_strong.dill` it compiles against,
  and the `dart` binary handed to `ServerProcess`.
- `tools/serverpod_cli/lib/src/commands/start/server_process.dart` — the default
  `dart` used to run the pod.
- `tools/serverpod_cli/lib/src/util/analysis_helpers.dart` — the analyzer's
  `sdkPath`.
- `tools/serverpod_cli/lib/src/commands/cloud.dart`.

### What breaks

**fvm projects cannot be created or started.** fvm does not install PATH shims.
It pins a version per project via `.fvmrc` and a `.fvm/flutter_sdk` symlink, and
expects tools to invoke `fvm flutter` or follow the symlink. A developer who
uses fvm exclusively has no `flutter` on `$PATH` at all, so
`_preCommandEnvironmentChecks` aborts every Serverpod command, even though a
perfectly good Flutter SDK is sitting behind the project's pin.

**The server is compiled by the wrong SDK, silently.** `serverpod_cli` is typically activated
with the system Dart, so `getSdkPath()` returns the system SDK. A project that
pins Flutter 3.32 via fvm still gets its server compiled and run by whatever
Dart happens to be running the CLI. There is no error — just a version skew
between the SDK the project declares and the SDK that builds it, surfacing later
as confusing analyzer or runtime errors.

## Overview

The CLI resolves a **Flutter SDK root** and a **Dart SDK root** once per
invocation, as early as possible, and every subprocess launch and SDK-path
consumer reads from that result. Resolution walks a fixed chain and stops at the
first tier that yields an SDK that actually exists on disk:

| # | Tier | Flutter | Dart |
| --- | ------ | --------- | ------ |
| 1 | PATH | `flutter` | `dart` |
| 2 | Running SDK | — | `getSdkPath()` |

Tier 1 asks the `flutter` on `$PATH` where its SDK lives. Version managers that
put a `flutter` shim on `$PATH` (asdf, mise, puro) answer with the SDK they
picked for the project, so the CLI uses the same SDK the developer's terminal
does. Tier 2 exists only for Dart as a last resort, it is what the CLI does
today.

`flutter` gets 30 seconds to answer, enough for one that is rebuilding its tool,
downloading SDK components, or waiting for its startup lock. One that has not
answered by then is stopped with a warning. Dart is
not resolved either: it is derived from Flutter, so falling back to the SDK
running the CLI would build the project with the wrong one. The command fails
saying that `flutter` did not answer, not that it is missing.

**Dart is derived from Flutter, not resolved separately.** Whenever a Flutter
root is resolved at tier 1, the Dart SDK is taken from
`<flutterRoot>/bin/cache/dart-sdk` rather than resolved independently. A project
pinned to Flutter 3.32 gets Dart 3.8, which is what `pub` in that project
expects.

### Resolution scope

The project pin is a property of a directory, not of the machine, so tier 1 is
resolved relative to a **base directory** that depends on the command:

- `serverpod create <name>` — the directory the project is being created into,
  before the project exists. A developer who has run `fvm use` in the parent directory gets that
  pinned SDK for the new project's `flutter create` and `pub get`.
- Every other command — the resolved server directory, falling back to the
  current working directory.

`flutter` runs in the base directory, so a version manager that binds an SDK to
a directory reports the project's SDK, the same one it picks in the
developer's terminal.

For a multi-app workspace, `flutter` is asked from each Flutter app's own
directory, so apps pinned to different Flutter versions each get their own SDK.

### fvm

fvm does not put a `flutter` on `$PATH` for pinned projects, and the CLI does
not special-case it. `flutter` can be rerouted to `fvm flutter` with a
script on `$PATH`, and with that in place fvm is resolved like any other
version manager:

```sh
#!/bin/sh
exec fvm flutter "$@"
```

On macOS/Linux, the script lives in a directory of its own, such as
`~/.fvm_shim`, at the front of `$PATH`.

On Windows, the equivalent is a `flutter.bat` file in a dedicated directory,
such as `%USERPROFILE%\.fvm_shim`, containing:

```bat
@fvm flutter %*
```

That directory sits at the front of the PATH environment variable.

Keeping the script in its own directory avoids overwriting another `flutter`.
It takes precedence when its directory comes before other Flutter directories
on PATH.

Two things follow from `fvm flutter`'s own behaviour:

- A project pinned to a version that is not installed yet gets it installed the
  first time the CLI asks `flutter` for its SDK, as it would in the terminal.
- With no project pin and no `fvm global` version, `fvm flutter` falls back to
  the `flutter` on `$PATH`, which is the script itself. Setting a global version
  avoids the loop.

### Behaviour of the environment checks

`_preCommandEnvironmentChecks` requires both SDKs up front and aborts when
either is missing. That requirement is kept. What changes is what it
consults.

**The check asks the resolver.** It still needs a `flutter` on `$PATH`, and
takes the SDK that `flutter` reports for the project. When there is none, the
error says how to put fvm behind a `flutter` on `$PATH`.

The pre-command check runs before command-specific project discovery, using
the resolver's initial current-directory scope. After `start` and `generate`
select their server package, they rescope the resolver for the SDK consumers
that perform analysis, compilation, and process launches.

**Commands still report Flutter problems at the point of use**, because the
up-front check cannot stand in for them. It resolves against the server
directory, while `serverpod start` resolves a Flutter SDK **per app** — a
workspace can pin different versions per app, so an individual app's pin can be
broken or absent even when the check passed. The SDK can also disappear between
the check and the launch, or its `bin/flutter` can fail to spawn on a cold
cache. `FlutterAppManager` therefore still reports a per-app failure and
releases the app's TUI tab.

### Diagnostics

Resolution is traceable. `serverpod version --verbose` reports the Flutter and
Dart SDK roots that were resolved. A Dart SDK under the Flutter root's
`bin/cache` was derived from it; any other is the SDK running the CLI.

The same two lines are logged at debug level on every command, so a bug report
that includes `--verbose` output answers "which SDK built this?" without a
follow-up question.

## Behaviour by command

**`serverpod create`** resolves against the target directory before writing
anything, so `flutter create` and the workspace `pub get` both run under the
project's pinned SDK. If no Flutter SDK is found and the template includes a
Flutter app, creation fails at the `flutter create` step with a message naming
the chain that was tried.

**`serverpod start`** resolves once at startup. The resolved Dart SDK becomes the
Frontend Server's `sdkRoot` and the source of `vm_platform_strong.dill`, and the
`dart` that runs the pod. The resolved Flutter SDK is what `FlutterProcess`
launches.

**`serverpod generate` and the analyzer-backed commands** use the resolved Dart
SDK for `analysis_helpers`, so analysis matches the SDK the project is compiled
with.

**`serverpod upgrade`** keeps using the CLI's own SDK. It updates the globally
activated CLI, which has nothing to do with the project's pin, and using a
project SDK here would install the CLI into the wrong place.

## Backwards compatibility

For a developer with a single system Flutter on `$PATH` and no fvm, resolution
lands on tier 1 and behaviour is unchanged.

Two behaviour changes are deliberate and affect existing users:

**Commands use the project's pinned SDK.** With a version manager behind
`flutter`, including fvm set up as above, the server and the Flutter app are
built by the SDK the project pins.

**The server may be compiled by a different SDK than before.** On a machine where
`flutter` on `$PATH` embeds a different Dart than the one running the CLI, tier 1
now wins over tier 2 and the server is built by the Flutter-embedded Dart.

## Design decisions

### Why the Dart SDK is derived from Flutter

Resolving the two independently is how the current split arose, and it lets the
server and the Flutter app be built by different SDKs on the same machine without
anyone noticing. Deriving Dart from the Flutter root leaves no supported way to introduce skew.

### Why resolve once per invocation rather than per call site

Per-call-site resolution is what produces the current inconsistency. Resolving
once means the diagnostics can state a single answer, the subprocess environment
can be constructed once, and it is impossible for the compiler and the pod to
disagree about which SDK they are using.
