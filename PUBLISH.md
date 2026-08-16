# Publishing Serverpod packages to pub.dev

Publishing Serverpod packages to `pub.dev` can be done through the automated CI pipeline or manually. The preferred method is to use the CI pipeline, as it ensures a consistent, secure, and reproducible release process.

## Pre-step: Version and changelog update

As a prerequisite for publishing, you need to:

1. Open a branch for the release.
2. Update the `version` in [SERVERPOD_VERSION](SERVERPOD_VERSION) to the new release version.
3. Update the central [CHANGELOG.md](CHANGELOG.md) file with the changes for the new version.
4. Generate the pubspecs for all packages by running [util/update_pubspecs](util/update_pubspecs).
5. Merge the changes into the main branch.

## Publish via CI pipeline (preferred method)

The CI pipeline is defined in [publish-serverpod.yaml](.github/workflows/publish-serverpod.yaml). It triggers automatically when a tag matching the version pattern is pushed (e.g. `2.9.1`, `3.0.0-alpha.1`, `3.0.0-rc.1`).

So, the only manual step is to **tag the merge commit from the previous step** with an annotated tag matching **the same version defined** in the [SERVERPOD_VERSION](SERVERPOD_VERSION) file and push to the upstream repository. Then, wait for the pipeline to complete.

```bash
# Replace VERSION and COMMIT_HASH with actual values
git tag -a VERSION COMMIT_HASH -m ""
git push upstream VERSION
```

### Recovering from errors

If any errors occur, the pipeline will fail and the errors will be logged in the GitHub Actions logs. It can be run again manually by triggering the workflow from the GitHub Actions tab using the "workflow dispatch" feature.

As the pipeline publishes packages in sequence, if the previous run successfully published some packages, but failed to publish others, it can be resumed by running the workflow again manually with the `start_package` parameter set to the index of the first package that failed to publish.

### Testing the pipeline (dry run mode)

When running the pipeline through the GitHub Actions tab, it can be tested in dry run mode by setting the `dry_run` parameter to `true`. This will validate the packages without publishing them.

## Publish manually (deprecated)

If you need to publish the packages manually for any reason, you can use the [util/publish_all](util/publish_all) script. This script will publish all packages in sequence, and can be resumed if it fails to publish some packages. This is the old method before the CI pipeline was introduced and is no longer recommended.
