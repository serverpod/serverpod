## 1.1.0
- feat: Lightweight run mode and support for serverless platforms.
- feat: Support for Google Cloud Platform deployments, including Terraform module.
- feat: Adds serializable exeptions that can be passed from the server to the client.
- feat: Adds `serverOnly` option to yaml-files, which is set to true will prevent the code to be generated for the client.
- feat: Support for `UUID` in serialization.
- feat: New supported static file types in Relic.
- feat: Allows endpoints in sub directories.
- feat: Support for GCP Cloud Storage.
- feat: Support for connecting to Postgres through a UNIX socket.
- feat: Adds database maintanance methods to Insights APIs (still experimental and API may change).
- docs: Improved documentation.
- fix: Better output on startup to aid in debugging connectivity issues.
- fix: Prevents self referencing table to cause `serverpod generate` to hang.
- fix: Adds email from Firebase to UserInfo in auth module.
- fix: Don't print stack trace when Google signin disconnect fails.
- fix: Return bool from `SessionManager.initizlize()` to indicate if server was reached.
- fix: Better recovery when parsing yaml-files.
- chore: Migrates Firebase to new Flutter APIs.
- chore: Updates dependencies.
- chore: Refactors CLI tooling.

## 1.0.1
- Fixes import of generics in subdirectories.
- Generated enums now respect their subdirectories.
- Masks out passwords in email debug logging.
- Replaces deprecated `docker-compose` with `docker compose`

## 1.0.0
- First stable release! :D
- Fixes incorrectly set database index on health metrics.

## 0.9.22
- Adds support for snake case in fields.
- Adds support for Duration data types in serialized objects.
- Correctly sets CORS headers on failed calls.
- Correctly imports generated files in subdirectories.
- Allows documentation in yaml files.
- Adds documentation for all generated code.
- __Breaking changes__: Optimizes health metric data. Requires updates to two database tables. Detailed migration instructions here: [https://github.com/serverpod/serverpod/discussions/567](https://github.com/serverpod/serverpod/discussions/567)

## 0.9.21
- Supports sub directories for protocol class files.
- Updates dependencies for auth module.
- Nicer default web page for new projects.
- Adds authentication example.
- Correctly inserts ByteData into the database.
- Much improved documentation for authentication.
- __Breaking changes__: The `active` and `suspendedUntil` fields of `UserInfo` in the auth module has been removed. These fields need to be removed from the database for authentication to work.

## 0.9.20
- New serialization layer thanks to the extensive work of [Maximilian Fischer](https://github.com/fischerscode). This adds compatibility with custom serialization, such as [Freezed](https://pub.dev/packages/freezed). It also adds support for nested `Map`s and `List`s.
- Updates examples.
- More extensive test coverage.
- Much improved documentation.
- __Breaking changes__: This version updates the Serverpod protocol, which is now much more streamlined ahead of the 1.0 release. Unfortunately, it makes apps built with earlier versions incompatible with the latest version of Serverpod. More detailed migration instructions here: [https://github.com/serverpod/serverpod/discussions/401](https://github.com/serverpod/serverpod/discussions/401)

## 0.9.19
- Adds support for storing and reading binary ByteData to/from the database.

## 0.9.18
- Adds chat module to published packages.

## 0.9.17
- Reliability fix for FlutterConnectivityMonitor on web platform.

## 0.9.16
- Changes default log level to `info`.
- Fixes issue with `serverpod create` command and updates template files with correct Flutter dependencies.

## 0.9.15
- Correctly sets 404 return code if no route is matched in Relic web server.
- Templates are updated to use latest version of flutter_lints.
- Adds connectivity monitor for streaming connections, which improves their reliability.

## 0.9.14
- Official support for Linux.
- Improved support for Windows.
- Adds tests for command line tools.

## 0.9.13
- Updates download path for template files.

## 0.9.12
- Adds `connecting` state to streaming connections.
- Refactors streaming connection method names to be more consistent (backwards compatible with deprecations).
- Adds `StreamingConnectionHandler` to automatically reconnect to the server when streaming connection is lost.
- Automatically upgrades streaming connections when a user is signed it (`serverpod_auth` module).
- Better error handling when providing invalid commands to the CLI.
- Moves tests to `serverpod_test_server`.
- Fixes error on `serverpod create --template module ...`
- Hides errors produced by health checks.

## 0.9.11
- Adds support for Map structures in serialized objects.
- Adds support for passing maps and lists as parameters to endpoint methods.
- Much improved error checks in code generation.
- Adds continuous code generation with `serverpod generate --watch`.
- Removes the `serverpod run` command in favor for continuous generation.
- Updates dependencies to latest versions.
- Cleans up `serverpod help` command.

## 0.9.10
- Brings example code up-to-date with latest changes in Serverpod
- Improved security for email sign in (limits sign in attempts based on a time period).
- Dart docs are now copied to generated code, making it easier to document APIs.
- Fixes issue with logging of queries in streaming sessions.
- Adds support for Sign in with Firebase.
- __Breaking changes__: Adds a new table for email sign in. Migration instructions here: [https://github.com/serverpod/serverpod/discussions/246](https://github.com/serverpod/serverpod/discussions/246)

## 0.9.9
- Improved Terraform scripts for AWS will use less resources. Most notably, only uses one load balancer which will fit within AWS free tier.
- Adds web server to Terraform scripts.
- Includes the Relic web server within the main Serverpod package.
- Much improved logging and health checks.
- Allows for monitoring of CPU and memory use.
- Many smaller bug fixes and improvements.
- __Breaking changes__: Updates config files and tables for logging. Migration instructions here: [https://github.com/serverpod/serverpod/discussions/190](https://github.com/serverpod/serverpod/discussions/190)

## 0.9.8
- Adds Terraform deployment scripts for AWS. Documentation here: [https://github.com/serverpod/serverpod/discussions/182](https://github.com/serverpod/serverpod/discussions/182)
- __Breaking change__: Updates structure of config files. Migration instructions here: [https://github.com/serverpod/serverpod/discussions/182](https://github.com/serverpod/serverpod/discussions/182)
- Moves Redis enabled option to config file and turns it off by default.
- `serverpod run` no longer manages the Docker containers as it caused an issue with restarting the server.

## 0.9.7
- `serverpod create` and `serverpod generate` is now working on Windows. Tested on a fresh install of Windows 10.

## 0.9.6
- Improved, but still experimental support for Windows.
- Fixes issue with error being thrown when internet connection is missing in CLI.
- Correctly ignores overridden methods of Endpoints in code generation.
- Makes using Redis optional.
- Much improved [documentation](https://docs.serverpod.dev).

## 0.9.5

- Adds `serverpod run` command and improves `serverpod create`.
- Continuous generation through `severpod run`.
- Automatic restarts through `serverpod run`.

## 0.9.4

- Updates to documentation.
- Makes it possible to cancel future calls.
- Improves accuracy in future calls.
- Saves/restores refresh tokens for Google sign in.

## 0.9.3

- Updates to documentation.

## 0.9.2

- Adds serverpod_auth module for authentication with email, Apple, and Google.

## 0.9.1

- Fixes broken images in documentation.

## 0.9.0

- Updates documentation and logos
- Ready for 0.9 release!

## 0.8.12

- Updates default templates.

## 0.8.11

- Improved ORM.
- Support for Docker.
- Chat module.
- Updated docs.

## 0.8.10

- Support for static file directories in Relic.
- Adds logos (psd and pngs).
- Adds example project.
- Initial version of authentication module.
- Cloud storage support.
- Adds auth module

## 0.8.6

- Adds documentation.
- Generates SQL files for creating database tables.

## 0.8.5

- Fixes compilation in broken serverpod_cli package

## 0.8.4

- Updates template files and fixes `serverpod create` command.
- Adds CHANGELOG.md

## 0.8.3

- Initial working version.
