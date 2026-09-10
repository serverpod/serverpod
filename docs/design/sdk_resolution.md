# Design: Dart and Flutter SDK resolution

This document describes how the Serverpod CLI decides which Dart and Flutter
SDK to use when it runs `pub get`, `flutter create`, `flutter run`, and when it
compiles and runs the server. Today that decision is made independently at
different call sites using two different and sometimes conflicting strategies.
This proposes a single resolution chain — **`SdkResolver`** — that every call
site consults, and which understands project-pinned SDKs (fvm) without any
configuration from the user.

The user-visible goal: a developer who pins Flutter with fvm should be able to
run `serverpod create` and `serverpod start` and have them work, with the
project's pinned SDK, without setting anything up.

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
| 1 | Project pin | `.fvm/flutter_sdk`, found by walking up | derived from the Flutter root |
| 2 | PATH | `flutter` | `dart` |
| 3 | Running SDK | — | `getSdkPath()` |

Tier 1 is the one that makes fvm work with no user action. Tier 3 exists only for
Dart as a last resort, it is what the CLI does today.

**Dart is derived from Flutter, not resolved separately.** Whenever a Flutter
root is resolved at tier 1 or 2, the Dart SDK is taken from
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

The upward walk stops at the same repository boundaries
`ServerpodDirectoryFinder` already uses (`.git`, `melos.yaml`, a workspace
`pubspec.yaml`, the home directory), so it never escapes the project and never
picks up an unrelated `.fvm` from a parent checkout.

For a multi-app workspace, the walk starts at each Flutter app's own directory,
so apps pinned to different Flutter versions each get their own SDK.

### Behaviour of the environment checks

`_preCommandEnvironmentChecks` requires both SDKs up front and aborts when
either is missing. That requirement is kept. What changes is what it
consults.

**The check asks the resolver, not `$PATH`.** A project with a
`.fvm/flutter_sdk` pin satisfies the Flutter requirement with no `flutter` on
`$PATH` at all.

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

Resolution is traceable. `serverpod version --verbose` reports what was resolved
and which tier it came from:

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
lands on tier 2 and behaviour is unchanged.

Two behaviour changes are deliberate and affect existing users:

**Commands work in a project pinned with fvm.** Previously-failing invocations
now succeed: the up-front check resolves the pin instead of requiring `flutter`
on `$PATH`.

**The server may be compiled by a different SDK than before.** On a machine where
`flutter` on `$PATH` embeds a different Dart than the one running the CLI, tier 2
now wins over tier 3 and the server is built by the Flutter-embedded Dart.

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
