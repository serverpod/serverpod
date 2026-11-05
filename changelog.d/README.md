# Changelog.d

This directory contains individual changelog files that should be added on each pull-request to be later collected in the main changelog. Files must be named like `<timestamp_yyyyMMddHHmmss>-PR<pr_number>-<author_nickname>.md`. And the content must contain a simple list of changes, as if they were changelog entries. Just the list of changes, with no additional description, since the PR already contains any extra details.

Example:

```
20261105120000-PR123-john_doe.md
```

Content:

```markdown
- feat: Adds ...
- fix: Fixes bug ...
```

When building the main changelog for a release, the content of the individual changelog files will be concatenated and sorted by timestamp, added to the main changelog file and the files will be deleted. No files should remain in this directory when building the main changelog.

## Why use a separate directory for changelog entries?

The main reason is to allow building an unreleased changelog as PRs come in, without the conflicts that would arise from entries added in concurrent PRs.

## Adding an entry

Once the pull request is open, run from the repository root:

```bash
dart run melos run changelog_add
```

The script detects the PR number and author with the [GitHub CLI](https://cli.github.com/), asks for the entries, and creates the file with the current UTC timestamp. Running it again for the same PR appends to the existing file. Commit the file with the rest of the PR.

Without the GitHub CLI, or before the PR exists, the script asks for the values instead. They can also be passed through melos, e.g. `dart run melos run changelog_add -- --pr 123 --author john_doe`.

For non-interactive use (scripts and agents), call the Dart script directly, since melos does not preserve the quoting of entries:

```bash
dart run util/changelog.dart add --pr 123 --author john_doe --entry 'feat: Adds X' --entry 'fix: Fixes Y'
```

Creating the file by hand is also fine, as long as it follows the rules below.

### Entry rules

- One entry per line, as a list item: `- <type>: <Description>`.
- `<type>` is one of `feat`, `fix`, `perf`, `refactor`, `docs` or `chore`. The other [PR title types](../.github/workflows/title-validation.yaml) (`build`, `ci`, `revert`, `style` and `test`) are always internal and are rejected.
- The description starts with an uppercase letter. Prefix breaking changes with `BREAKING.`, e.g. `- feat: BREAKING. Removes ...`.
- Indented lines continue the previous entry.

CI validates the files on every PR. To check them locally, run `dart run melos run changelog_check`.

### Writing style

Follow the style of the existing entries in [CHANGELOG.md](../CHANGELOG.md):

- Be objective: state what changed and its effect for users, in a single sentence ending with a period. Avoid subjective or promotional wording (e.g. "great", "amazing", "much better") and implementation details that users do not see.
- Start with a verb in the present tense, third person: "Adds", "Fixes", "Removes", "Allows", "Prevents", "Improves". Not "Add", "Added" or "Adding".
- Describe one change per entry. Split unrelated changes into separate entries.
- Wrap code identifiers, commands, files and packages in backticks, e.g. `Model.db.watch`, `serverpod start`, `SERVERPOD_VERSION`.

For example:

```markdown
- feat: Adds `serverpod runner` command with `start`, `attach`, `status` and `stop` subcommands.
- fix: Returns 400 instead of 500 for malformed endpoint argument values.
- perf: Speeds up deserialization of shared and module models by ~x3.
- refactor: BREAKING. Merges normal and `*withOptions` methods on the `CloudStorage` interface.
```

### User-facing and internal changes

The changelog is for Serverpod users, so only user-facing changes get an entry. A change is user-facing when it changes either:

- The public interface: the public API of the published packages, the generated code, the `serverpod` CLI commands and options, the project templates or the public API docs.
- The behavior users observe, even if no interface changes: results, defaults, error handling and messages, logs, performance, database and migration output, or compatibility with Dart, Flutter and other dependencies.

Everything else is internal. A PR with only internal changes does not add a file, and a PR that mixes both only lists the user-facing ones. Internal changes include:

- Build, CI, test, formatting and revert changes (the `build`, `ci`, `test`, `style` and `revert` types).
- Fixes and improvements to the repository's own tooling only, such as the `util` scripts, melos scripts, GitHub workflows and the test infrastructure.
- Documentation of non-public interfaces or design documents only, such as doc comments on internal code or the files in [docs](../docs).
- Refactors and dependency updates that change neither the public interface nor the behavior.
- Fixes to changes that were not released yet. Update the original entry instead, if needed.

When in doubt, anything a user could notice after upgrading is user-facing.

## Previewing the unreleased changelog

```bash
dart run melos run changelog_preview
```

Prints the pending entries in the order they will be collected.

## Releasing

As part of the release PR (see [PUBLISH.md](../PUBLISH.md)), after updating `SERVERPOD_VERSION`, run:

```bash
dart run melos run changelog_collect
```

This adds a `## <version>` section with all pending entries to the top of [CHANGELOG.md](../CHANGELOG.md) and deletes the entry files. Pass `-- --version <version>` to use a different heading. The script refuses to run if any entry file is invalid or if the version already has a section, so nothing is lost or left behind. Then edit the new section as needed (grouping entries, adding highlights) before running `util/update_pubspecs`.
