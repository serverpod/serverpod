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
