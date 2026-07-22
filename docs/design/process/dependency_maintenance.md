# Dependency maintenance

Guidelines for choosing, widening, and retiring the dependency constraints
declared across the repository's packages.

## Constraint policy

Dependency lower bounds must resolve with the repository's minimum supported
Dart and Flutter versions. A lower bound should be the oldest version Serverpod
actively supports and verifies, not the newest version currently available or
selected by a normal `pub get`. Raise it only when Serverpod uses an API added
later, needs a bug or security fix, encounters an SDK incompatibility, or cannot
resolve and analyze a supported package graph without the newer version. Upper
bounds should remain as wide as the APIs and semantic-versioning guarantees
allow.

An SDK or transitive dependency may make Pub select a version above Serverpod's
declared floor in one graph. That alone is not a reason to raise the floor.
Flutter, for example, can select newer releases to satisfy its own pins while
Dart-only Serverpod packages continue to support their older declared bounds.
Conversely, a security fix or an API used directly by Serverpod should be
reflected in the declared lower bound.

The downgrade check can surface a transitive package whose oldest permitted
release cannot compile on a supported SDK. Pin such a package with a direct
constraint that excludes the invalid releases, and comment the constraint with
the selection it prevents. These pins should stay as narrow as the defect
requires, and be removed once the upstream graph no longer permits the broken
selection.

Repository-wide tooling migrations, such as moving the workspace to a new major
of the package manager, change every member package and should be handled
separately from dependency constraint maintenance.

## Cross-package version matching

`serverpod analyze-pubspecs` requires that a dependency shared by several
packages is declared with the same constraint everywhere. When packages must
diverge deliberately, for example when a frozen legacy package keeps an older
constraint that the current packages have moved past, add the dependency to
`ignore_packages` under `serverpod_cli.analyze_pubspecs` in the root
`pubspec.yaml`. Prefer converging the constraints over adding an exception, and
treat each entry as a temporary allowance rather than a permanent one.

## Evaluating a major version bump

A new major of a dependency is not automatically a breaking change for
Serverpod. Before widening or raising a bound, establish what actually changed:

- Diff the dependency's public Dart API between the current and candidate
  versions rather than relying on the changelog alone. Changelogs describe the
  break for all consumers, not for this repository.
- Determine which of the changed APIs Serverpod uses. A rename or removal in a
  widget or helper the repository never references does not affect it.
- Check the transitive majors the bump carries. A major caused only by additive
  enum cases is breaking solely for exhaustive switches, so it matters only if
  the repository switches over that enum.
- Compare the candidate's own SDK constraints against the floors the depending
  packages declare. When the candidate requires newer SDKs, a widened range
  self-gates: the floor keeps resolving to the older release while current
  toolchains select the newer one. Both ends must then be verified.
- For Flutter plugins, review the native and packaging changes as well. Platform
  build baselines, deployment targets, and plugin layouts usually follow from
  the required Flutter version rather than from Serverpod.
- Consider whether the changed API is re-exported. An API the repository does
  not use itself can still reach downstream users through a barrel file or a
  public signature.

Record the conclusion of a non-obvious evaluation in the pull request, so the
reasoning is available the next time the same dependency moves.

## Screening for unmaintained dependencies

Release age is a screening signal, not a verdict. Many Dart and Flutter core
packages are stable components of active monorepos and do not need frequent
releases. Before proposing a replacement, check repository activity, open
compatibility defects, and security advisories, and weigh how much of the
package's surface Serverpod actually uses.

Removing an unused direct declaration is always preferable to replacing it. A
package that is only reachable transitively does not need a direct constraint,
and dropping the declaration reduces the surface without any behavior change.

When a replacement is genuinely warranted, propose it with its trade-offs rather
than applying it as part of a constraint audit. Dependencies that feed generated
identifiers, database artifacts, or rendered branding need parity or golden
tests proving the behavior is unchanged before any switch.

## Validation

Validate changes with the minimum SDK versions and run:

```console
melos bootstrap
melos downgrade
melos lint_loose
serverpod analyze-pubspecs
```

The commands must pass. Normal and latest dependency resolution should also be
analyzed so both ends of the supported range remain healthy, and packages whose
constraints changed should have their tests run at both ends.

Two things to confirm about the run itself:

- Check that each command actually enumerated the workspace packages. Melos
  aborts package discovery when the workspace globs match stray directories,
  such as scratch projects left behind by the CLI tests, and the aborted run
  can still report success.
- Run `serverpod analyze-pubspecs` from the branch's own CLI source, as
  `util/run_tests_update_pubspecs` does. A globally activated CLI from an
  earlier release will not have the branch's ignore paths and reports
  mismatches that do not exist.

`melos downgrade` rewrites every lockfile to the declared floors. Restore a
normal resolution afterwards, otherwise later work runs against the floor graph.
