/// This file is auto-generated.
library;

import 'package:cli_tools/better_command_runner.dart' show CompletionTool;

const String _completionScript = r'''
# yaml-language-server: $schema=https://carapace.sh/schemas/command.json
name: serverpod
persistentFlags:
  -q, --quiet: "Suppress all cli output. Is overridden by  -v, --verbose."
  -v, --verbose: "Prints additional information useful for development. Overrides --q, --quiet."
  -a, --analytics: "Toggles if analytics data is sent. "
  --no-analytics: "Toggles if analytics data is sent. "
  --interactive: "Enable interactive prompts. Automatically disabled in CI environments."
  --no-interactive: "Enable interactive prompts. Automatically disabled in CI environments."
  --version: "Prints the active version of the Serverpod CLI."
  --experimental-features=*: "Enable experimental features. Experimental features might be removed at any time."
exclusiveFlags:
  - [analytics, no-analytics]
  - [interactive, no-interactive]

commands:
  - name: completion

    commands:
      - name: generate
        flags:
          -t, --tool=!: "The completion tool to target"
          -e, --exec-name=: "Override the name of the executable"
          -f, --file=: "Write the specification to a file instead of stdout"
        completion:
          flag:
            tool: ["completely", "carapace"]
            file: ["$files"]

      - name: install
        flags:
          -t, --tool=!: "The completion tool to target"
          -e, --exec-name=: "Override the name of the executable"
          -d, --write-dir=: "Override the directory to write the script to"
        completion:
          flag:
            tool: ["completely", "carapace"]
            write-dir: ["$directories"]

  - name: cloud

  - name: create
    flags:
      -f, --force: "Create the project even if there are issues that prevent it from running out of the box."
      --mini: "Shortcut for --template mini."
      -t, --template=: "Template to use when creating a new project"
      -n, --name=!: "The name of the project to create.\nCan also be specified as the first argument."
    completion:
      flag:
        template: ["mini", "fullstack", "server", "module"]

  - name: database

    commands:
      - name: start
        flags:
          -s, --server-dir=: "Server project directory. Defaults to auto-detection."
          -m, --mode=: "Serverpod run mode whose database config should be used."
          -p, --port=: "TCP port override. Defaults to the configured database port."

  - name: quickstart
    flags:
      -f, --force: "Create the project even if there are issues that prevent it from running out of the box."
      -t, --template=: "Template to use when creating a new project"
      -n, --name=!: "The name of the project to create.\nCan also be specified as the first argument."
    completion:
      flag:
        template: ["fullstack", "server", "module"]

  - name: generate
    flags:
      -w, --watch: "Watch for changes and continuously generate code."
      -d, --directory=: "The directory to generate code for (defaults to current directory)."
      -f, --force: "Regenerate even when the output looks up to date. Use this to rebuild after hand-editing or reverting generated files."

  - name: language-server
    flags:
      --stdio: ""
      --no-stdio: ""
    exclusiveFlags:
      - [stdio, no-stdio]

  - name: mcp-server
    flags:
      -s, --server-dir=: "Path to the server project directory (the package that contains a `serverpod` dependency). Auto-detected from the current working directory if omitted. Pass this flag explicitly in monorepos with multiple server projects."

  - name: create-migration
    flags:
      --empty: "Creates the migration even if there are no database changes."
      -f, --force: "Creates the migration even if there are warnings or information that may be destroyed."
      -t, --tag=: "Add a tag to the revision to easier identify it."

  - name: create-repair-migration
    flags:
      -f, --force: "Creates the migration even if there are warnings or information that may be destroyed."
      -t, --tag=: "Add a tag to the revision to easier identify it."
      -v, --version=: "The target version for the repair. If not specified, the latest migration version will be repaired."
      -m, --mode=: "Used to specify which database configuration to use when fetching the live database definition."
    completion:
      flag:
        mode: ["development", "staging", "production"]

  - name: run
    flags:
      --script=: "The name of the script to run."
      -l, --list: "List all available scripts."
      --no-list: "List all available scripts."
    exclusiveFlags:
      - [list, no-list]

  - name: start
    flags:
      -w, --watch: "Watch files and use the Frontend Server for fast incremental compilation. With --no-watch, the server is started via `dart run`."
      --no-watch: "Watch files and use the Frontend Server for fast incremental compilation. With --no-watch, the server is started via `dart run`."
      -d, --directory=: "The server directory (defaults to auto-detect from current directory)."
      --docker: "Start Docker Compose services if a Docker Compose file exists. Defaults to on if the project has a Docker Compose file and the database is configured to PostgreSQL without a dataPath. Otherwise, defaults to off. Pass --docker or --no-docker to override the default behavior."
      --no-docker: "Start Docker Compose services if a Docker Compose file exists. Defaults to on if the project has a Docker Compose file and the database is configured to PostgreSQL without a dataPath. Otherwise, defaults to off. Pass --docker or --no-docker to override the default behavior."
      --tui: "Show interactive terminal UI."
      --no-tui: "Show interactive terminal UI."
      --flutter: "Auto-launch the companion Flutter apps as configured on the server pubspec.yaml with `auto_launch: true`. Use --no-flutter to disable auto-launch. Apps can still be started on demand from the TUI."
      --no-flutter: "Auto-launch the companion Flutter apps as configured on the server pubspec.yaml with `auto_launch: true`. Use --no-flutter to disable auto-launch. Apps can still be started on demand from the TUI."
    exclusiveFlags:
      - [watch, no-watch]
      - [docker, no-docker]
      - [tui, no-tui]
      - [flutter, no-flutter]

  - name: upgrade

  - name: version


''';

/// Embedded script for command line completion for `carapace`.
const completionScriptCarapace = (
  tool: CompletionTool.carapace,
  script: _completionScript,
);
