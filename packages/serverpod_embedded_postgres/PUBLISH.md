# Publishing embedded PostgreSQL bundles

Publishing the PostgreSQL + PostGIS + pgvector bundles is done through the
automated CI pipeline. The pipeline builds and tests every supported platform,
assembles an all-or-nothing GitHub Release, and publishes it only after all
assets have been verified.

## Pre-step: Bundle version and specification update

As a prerequisite for publishing, you need to:

1. Open a branch for the bundle update.
2. Choose the bundle identity in the form `<postgres-bom>-r<bundle-revision>`,
   for example `16.13.0-r1`.
3. Update [versions.env](tool/build_postgres/versions.env) with the PostgreSQL
   BOM, bundle revision, dependency versions, and source hashes.
4. Update [bundle_spec.dart](lib/src/binary/bundle_spec.dart) with the same
   PostgreSQL version, bundle revision, PostGIS version, and pgvector version.
5. If the PostgreSQL version changed, also update `defaultPostgresVersion` in
   [options.dart](lib/src/options.dart) and `_defaultVersionLiteral` in
   [prefetch.dart](bin/prefetch.dart).
6. Run the local checks from the package directory:
   ```bash
   dart test test/api_smoke_test.dart test/binary/bundle_spec_test.dart test/tool
   dart analyze
   ```
7. Open a pull request, wait for CI to pass on every supported platform, and
   merge it into the main branch.

> For a PostgreSQL version that has never been bundled, start at revision 1. If
> a bundle is already published and the update can change any shipped byte,
> increment the revision. This includes dependency, source, checksum, compiler,
> linker, build flag, relocation, and packaging changes.

Runtime-only Dart changes, tests, documentation, and post-build smoke checks
do not require a new revision because they do not change bundle bytes.

Never replace assets in a published release. Publish a correction to
`16.13.0-r1` as `16.13.0-r2`. The revision is included in archive names,
download URLs, manifests, and cache paths, so the corrected bundle cannot be
confused with a cached older revision.

## Publish via CI pipeline

The [CI pipeline](../../.github/workflows/build-embedded-postgres.yaml)
triggers automatically when a tag is pushed matching the pattern:

```plaintext
embedded-postgres-v<postgres-bom>-r<bundle-revision>
```

Tag the merge commit from the previous step with an annotated tag matching
the `PG_BOM` and `BUNDLE_REVISION` values in
[versions.env](tool/build_postgres/versions.env), then push it to the upstream
repository:

```bash
# Replace BUNDLE_ID and COMMIT_HASH with actual values.
BUNDLE_ID=16.13.0-r1
git tag -a "embedded-postgres-v$BUNDLE_ID" COMMIT_HASH \
  -m "Embedded PostgreSQL bundle $BUNDLE_ID"
git push upstream "embedded-postgres-v$BUNDLE_ID"
```

Then, wait for the pipeline to complete. Do not create or populate the GitHub
Release manually.

The pipeline:

1. Builds Linux x64, Linux ARM64, macOS x64, macOS ARM64, and Windows x64.
2. Packages an archive and SHA-256 sidecar for each platform.
3. Runs the bundle smoke contract on every platform.
4. Requires all five archives, all five sidecars, and `recipe.sha256`.
5. Uploads the 11 assets to a draft release and verifies the asset count.
6. Publishes the draft only after every previous step succeeds.

The release build always starts from the tagged source. It does not reuse the
temporary bundle built by pull request CI.

### Recovering from errors

If a build or smoke job fails, the publish job will not run and no draft will
be created.

- For a transient failure, rerun the failed jobs or the workflow.
- If the fix changes the tagged build recipe, merge the fix, increment the
  bundle revision, and publish a new tag. Do not move the existing tag to
  different source.

If asset upload, asset verification, or final publication fails, a partial
draft may remain. Rerun the failed jobs or workflow. On the next serial run,
the publish job will:

1. Stop if the release is already published.
2. Delete matching drafts left by previous attempts.
3. Create and verify a new draft.

Do not run two publication attempts for the same tag concurrently. The
workflow has no concurrency lock, so their draft cleanup can race.

If the runner lost contact while publishing, inspect the release before
rerunning. A rerun intentionally refuses to modify an already-published
bundle.

Never move a published tag, replace its assets, or reuse its revision for
different bytes.

### Testing the pipeline without publishing

The pipeline can be tested from the GitHub Actions tab using the
`workflow_dispatch` trigger. A manual run builds, packages, and smoke-tests all
five platforms, but it never runs the publish job.

To start a manual run against the main branch with the GitHub CLI:

```bash
gh workflow run build-embedded-postgres.yaml \
  --repo serverpod/serverpod \
  --ref main
```

Pull request CI follows a similar non-publishing path. It uses a released
bundle only when its recipe hash matches the checked-out source; otherwise it
builds a temporary bundle to test the commit.

## Verify the published release

After the pipeline succeeds, verify the release with the GitHub CLI:

```bash
BUNDLE_ID=16.13.0-r1
TAG="embedded-postgres-v$BUNDLE_ID"

gh release view "$TAG" --repo serverpod/serverpod \
  --json tagName,isDraft,assets
gh release view "$TAG" --repo serverpod/serverpod \
  --json assets --jq '.assets | length'
```

Confirm that `isDraft` is `false`, the tag is correct, and the asset count is
11. Then, download the host bundle through the same runtime path used by
Serverpod users:

```bash
cd packages/serverpod_embedded_postgres
dart run serverpod_embedded_postgres:prefetch --version 16.13.0
```

Replace the example version with the PostgreSQL version being published. Do
not publish a Serverpod package version that references the bundle until this
download succeeds.

Each Serverpod package version remains pinned to the exact revision in its
`BundleSpec`. Users receive a later revision only after upgrading to a
Serverpod package version that references it.

## Building a bundle locally

Install the platform toolchain described in the
[build guide](tool/build_postgres/README.md), then run the build from the
repository root:

```bash
export PGBUILD=/tmp/serverpod-pgbuild
bash packages/serverpod_embedded_postgres/tool/build_postgres/build-all.sh
```

The build is native, not cross-compiled. Run it on the OS and architecture for
the bundle you want to produce. Linux uses Zig 0.16.0, macOS uses Apple clang,
and Windows uses mingw-w64 GCC. On Windows, run the same command from an MSYS2
MINGW64 shell and use an MSYS path for `PGBUILD`, for example
`/c/temp/serverpod-pgbuild`.

The completed archive and its SHA-256 sidecar are written to
`$PGBUILD/dist/`:

```text
serverpod-postgres-<bom>-r<revision>-<os>-<arch>.tar.xz
serverpod-postgres-<bom>-r<revision>-<os>-<arch>.tar.xz.sha256
```

On Linux or macOS, extract and smoke-test the completed archive before using
it:

```bash
bundle_dir="$(mktemp -d)"
tar -C "$bundle_dir" -xf "$PGBUILD"/dist/serverpod-postgres-*.tar.xz
bash packages/serverpod_embedded_postgres/tool/smoke_bundle.sh "$bundle_dir"
```

On Windows, run the equivalent smoke test from MSYS2 under a limited
non-administrator token:

```bash
bundle_dir="$(mktemp -d)"
tar -C "$bundle_dir" -xf "$PGBUILD"/dist/serverpod-postgres-*.tar.xz
bash packages/serverpod_embedded_postgres/tool/smoke_bundle_windows.sh \
  "$bundle_dir"
```

PostgreSQL refuses to start under an Administrators-group token; CI creates
the required token with `PsExec -l`. See [PLATFORMS.md](PLATFORMS.md) for the
Windows limitation.

A local build is only for development and diagnosis. It does not publish an
asset and does not replace the five-platform release workflow.
