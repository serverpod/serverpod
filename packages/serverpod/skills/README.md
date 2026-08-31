# Serverpod Agent Skills

[Agent Skills](https://agentskills.io/specification) for the Serverpod framework. Each skill has YAML frontmatter (`name`, `description`) and a Markdown body.

They ship inside the `serverpod` pub package and are installed into a project's IDE directory by the [`skills`](https://pub.dev/packages/skills) CLI (`skills get`), which `serverpod create` runs for the selected IDEs.

## Writing and changing skills

- **Directory name.** Must start with `serverpod-`, and `name` in the frontmatter must match the directory name. The `skills` CLI silently skips skills that break this.
- **Description.** This is the only part loaded into every agent context, and it decides when the skill activates. State what it covers and when to use it, and point at the neighbouring skill when the boundary is easy to cross ("To query the ORM instead, use serverpod-database").
- **Body.** Write for an agent: prescriptive, example-first, no marketing. Keep it to what cannot be guessed from general Dart or HTTP knowledge.
- **Reference files.** Lookup material (long tables, secondary features) belongs in `references/*.md` inside the skill directory, linked from `SKILL.md`. The whole directory is installed, so the agent reads those files only when it needs them.
- **Length.** `SKILL.md` under 500 lines, and shorter is better — every activation pays for it.
- **Cross-links.** Use relative paths, e.g. `../serverpod-migrations/SKILL.md`.
- **Keep them true.** Verify against the code in this repository, not memory, and update the skills in the same PR that changes the API they describe.
