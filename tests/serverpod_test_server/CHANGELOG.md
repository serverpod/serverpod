## 1.2.4
- fix: Sets the correct output path for generated files on Windows.
- fix: Prevents VS Code extension from crashing on startup.
- fix: Marks file handling database methods as deprecated.
- fix: Correctly handles transaction parameters for delete method.
- fix: Correctly resolves and validates registered custom classes used as types in model fields.

## 1.2.3
- fix: Correctly cleans up health check manager when shutting down server.
- fix: Supports projects without a config generator file in CLI.
- fix: Adds additional requirements to Insights setup.
- fix: Removes unnecessary database connection creation in pool manager.
- fix: CLI gives error if non-string value is used as parent keyword.

## 1.2.2
- fix: Makes it possible to create modules from templates in developer mode.
- fix: Correctly marks nested enum types in the analyzer.
- fix: Adds support for all Serverpod's supported types as keys in Maps.
- fix: Restric fields with scopes other than all to be nullable.
- fix: Uses pubspec override instead of direct paths (to improve score on pub.dev).
- fix: Less restrictive enum naming rules.
- fix: Pins Dart and Busybox docker image versions (only for new projects).
- fix: Deterministically truncate list aliases in database relations.
- fix: Enables server to start without migrated database.
- fix: Adds missing deprecation messages.
- fix: Adds placeholder for old postgres file, to aid users who are following old tutorials.
- fix: Resolves internal relation pointers in class representations.

## 1.2.1
- fix: Removes old generated folder from Dockerfile.
- fix: Prevents database analyzer from crashing when missing table.
- fix: Fixes issue with DevTools extension not being bundled with the `serverpod` package.
- fix: Ingores all null fields in JSON map serialization.
- fix: Improved error message if port is in use when starting server.
- chore: Bumbs `vm_service` version to support latest version.

## 1.2.0
This is a summary of the new features in version 1.2.0. For the full list, please refer to the [commits](https://github.com/serverpod/serverpod/commits/main/) on Github. Instructions for updating from 1.1 of Serverpod is available in our documentation [here](https://docs.serverpod.dev/upgrading/upgrade-to-one-point-two).

### Main new features and fixes
- feat: Adds official support for Windows.
- feat: Adds Visual Studio Code extension.
- feat: Syntax highlighting in model files.
- feat: Adds LSP server for analyzing model files.
- feat: CLI automatically detects modules withouth the need to modify the generator file.
- feat: Validates project names on `serverpod create`.
- feat: Validates Serverpod packages and CLI version in `serverpod generate`.
- feat: Prompts user to update Serverpod when running an old version of the CLI.
- feat: Improves exit codes for CLI.
- feat: Improvements to output from CLI, including different formats for different platforms and run-modes.
- feat: Progress animations in CLI.
- feat: Uses CommandRunner for CLI.
- feat: Adds global `--verbose` and `--quiet` flags to control log level.
- feat: Developer version of `serverpod create` now creates a project referring to the local version of Serverpod.
- feat: Adds `copyWith` methods on all generated model files.
- feat: Makes it possible to call endpoint methods by specifying the method name in the path.
- feat: Makes return headers configurable for API and OPTION HTTP calls.
- feat: Adds `fromYaml` constructor to `ServerpodConfig`.
- feat: Adds reference to all modules in config.
- feat: Makes HTTP timeout configurable.
- feat: Improves compatibility for `serverpod create` by not running Docker through tooling.
- fix: Makes endpoint classes public to enable Dart doc.
- fix: Serializable exceptions now work with modules.
- fix: Handels invalid return types when parsing endpoint methods.
- fix: Fixes localhost on Android emulator.
- fix: Use explicit version for all Serverpod packages.
- fix: Uses git version of CLI in local tests.
- fix: Fixes typos in `serverpod create` start instructions.
- fix: Makes include class fields private.
- fix: Adds flag to disable analytics reporting.
- fix: Correctly resets error message state when and endpoint call was successful in template project.
- fix: Closes session when protocol exception is thrown.
- fix: Allows deeply nested `Map` and `List` in model files.
- docs: Many improvements to API documentation.
- chore: Updates to latest version of Flutter.
- chore: Updates dependencies.
- chore: Fixes deprected methods.
- chore: Makes Dart & Flutter version requirements consistent across packages.
- chore: Adds serverpod_lints package.
- ci: Now runs tests on multiple Flutter versions.
- ci: Adds 2000 new tests.
- ci: Unit tests are now running on Windows.

### Database ORM
- feat: Adds support for database migrations.
- feat: Adds support for database repair migrations.
- feat: Adds support for database relations.
- feat: Support `IN`, `NOT IN`, `BETWEEN` and `NOT BETWEEN` query operations.
- feat: Separates `Column` from `Expression` and harmonizes operations.
- feat: Adds scoped database operations on generated models.
- feat: Adds batch `insert`, `update`, and `delete` database operations.
- feat: Exposes mapped results database query for public use.
- feat: Adds `notLike` and `notILike` on database `String` expressions.
- feat: Adds column selection to generated update method.
- fix: Adds helpful error message if wrong table is used for `where` or `orderBy` expression.
- fix: Change signature of `orderBy` and `orderByList` to callback taking a typed table.
- fix: Removes old Postgres generator (replaced by migrations).

### Model files (.spy.yaml) and code generation
- feat: Dual pass parsing when validating model files.
- feat: Validates field datatypes when running `serverpod generate`.
- feat: Adds deprecation warnings to old model file keywords.
- feat: Adds severity levels to reported errors in analyzer.
- feat: Adds ability to toggle implicit key in stringified nodes.
- feat: Reports severity level of errors.
- feat: Adds `scope` and `persist` keywords to models.
- feat: Adds `onDelete` and `onUpdate` bindings.
- feat: Introduces reserved keywords in protocols.
- feat: Adds serialization `byName` option for enums.
- feat: Allow `.spy` file extension on model files (default is now `.spy.yaml`).
- feat: Now loads model files from `src/lib/models` directory (old `protocol` directory is still supported for backward compatibility).
- feat: Adds type validation to model files.
- fix: Allows multiple uppercase characters in model class names.
- fix: Protocol entities only allowed to be one type.
- fix: Better error messages for `fields` in model files.
- fix: Enforce index types to be a valid Postgres index type.
- fix: Require all serialized enum values to be unique.
- fix: Enforce that the `id` field isn't used for models that have a table defined.
- fix: Enforce that `parent` keyword is only used if a model has an associated table.
- fix: Report an error if the referenced parent table does not exists.
- fix: Report an error if the table name in a model is not globally unique.
- fix: Report an error if an index name is not globally unique.
- fix: Report an error if a field is referenced twice in the same index.
- fix: Allows complex types to be nullable.
- fix: Parse the source location for all comma separated values in a field string.
- fix: Restrict class names to now allow standard datatypes.
- fix: Add automatic deprecated reporting of keys in analyzer.
- fix: Set exit code to non-zero if generator finds issues.
- fix: Correctly validate deeply nested datatypes in protocols.
- fix: Enum value restrictions matches default linting in Dart.
- fix: Less restrictive naming of model class names.
- fix: Avoid generating code from broken protocol files.
- fix: Deprecate `database` and `api` keywords.
- fix: Stop generator from getting stuck on circular dependencies.
- fix: Handle invalid YAML errors and report them.
- fix: Only report duplicated and invald negations once.
- fix: Adds deep check of `DateTime` and `Uint8List` during deserialization.
- fix: Deserialization of `DateTime` handles `null` explicitly.
- fix: Only return valid entries from analyzer.
- fix: Reintroduces generation of `protocol.yaml`.
- fix: Use version command to check if a command exists.
- fix: Prevents `generate --watch` from crashing.
- fix: Prevents analyzer from crashing because of invalid Dart syntax.
- fix: Prevents analyzer from crashing when an unsupported type is used.
- fix: Avoid serializing null `Map` values.
- fix: Restrict length of user defined Postgres identifier names.

### Insights
- feat: Insight endpoint methods for running queries and fetching full database configuration.
- feat: Adds module name and Dart class names to table definitions in Insights protocol.
- feat: Support for filtering bulk data fetched from Serverpod Insights.
- feat: Adds API for accessing files local to the server.
- fix: Include installed modules in all database definitions.

### Auth module
- feat: Improves auth example.
- feat: Adds Sign in with Apple button.
- feat: Adds Google Sign in on the web.
- feat: Allows min and max password lengths to be configured in auth module.
- feat: Allows label and icon to be customized for Sign in with Email button in auth.
- fix: Removes dead code in auth module.
- fix: Adds error message if email is already in use in auth.
- fix: Properly close barrier when sign in is complete in auth.
- fix: Corrects typo in sign in button.
- fix: Require consent in order to generate refresh token for Google Signin.
- fix: Throw descriptive error if Google auth secret is not loaded on the server.
- fix: Typo in reset password example email.
- fix: Enforces user blocked status on login.
- fix: Allows Firebase phone auth and logs auth errors.

### File storage
- feat: Adds bulk file URL lookup method for file storage.

### Chat module
- fix: Adds missing return statement to require authentication.


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
