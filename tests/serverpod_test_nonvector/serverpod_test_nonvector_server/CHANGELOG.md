## 2.7.0
- feat: Adds support for storing `String`-representable user id in `AuthenticationInfo`.
- feat: Adds support for `UUIDv7` as a default value in models.
- feat: Adds support for the `@doNotGenerate` annotation for endpoint methods. (Replaces `@ignoreEndpoint`.)
- feat: Adds support for configuring execution, scan interval, and concurrency limit for future calls.
- fix: Fixes an issue where migrations could add foreign key relations before their associated table was created.
- fix: Prevents multiple servers from running migrations in parallel.
- fix: Fixes an issue where the end of a call would not be logged to the console.
- fix: Failed health checks now respond with a 503 status code.

## 2.6.0
- feat: Adds support for endpoint inheritance.
- feat: Adds support for `@ignoreEndpoint` annotation for endpoint methods.
- feat: Updates the starter template for new Serverpod projects.
- fix: Removes unnecessary stack trace from platforms that do not support health checks.
- fix: Fixes an issue where the `serverpod generate` command would fail in workspace setups.
- fix: Silences error reporting for authentication rejections in legacy streaming endpoints.
- feat(EXPERIMENTAL): Adds support for using `UuidValue` as the type for model `id` fields.

## 2.5.1
 - feat: Adds support for configuring database search path across all database connections.
 - fix: Limits version compatibility check to `serverpod` and `serverpod_client` packages.
 - fix: Fixes an issue where record parameters could only be named `record`.

## 2.5.0
- feat: Enables translations for SignInWithEmailDialog.
- feat: Adds support for `Record` type in Streaming methods.
- feat: Adds support for `Record` type in models.
- feat: Adds support for defining a default value for `Enum` models.
- feat(EXPERIMENTAL): Adds support for attaching custom data to diagnostic events.
- fix: Always drains request bodies to prevent unexpected closed connections in the client.
- fix: Prevents generated model file naming conflicts with framework-generated files.
- fix: Fixes crash when validating Serverpod package version in CLI.
- fix: Preserves stack trace in database query exceptions.
- fix: Fixes crash in update queries for models without fields or when id column is specified.
- fix: Fixes import issue causing WASM incompatibility in client.
- fix: Re-enables support for models named "Record".
- fix: Fixes issue where implicit relations could be dropped during update database operations.
- fix: Fixes issue where implicit relations were not preserved during serialization roundtrips.
- fix: Adds support for non-nullable `Set` in models.
- fix(EXPERIMENTAL): Includes Uri path in diagnostic events.
- fix(EXPERIMENTAL): Reports diagnostic event on exception during database start and health checks.

## 2.4.0
- feat: Adds support for configuring certificates for Serverpod API, Web, and Insights servers.
- feat: Adds support for `Uri`, `BigInt`, and `Set` type in endpoints and models.
- feat: Adds support for `Record` type in endpoint `Future` return and parameters.
- feat: Adds support for `List` and `Set` containers in Streaming methods.
- feat: Adds option to disable caching for static content matching a regexp path in the web server.
- feat: Gracefully shuts down server on `SIGTERM` signal.
- feat: Allows configuration of server id via the `SERVERPOD_SERVER_ID` environmental variable.
- feat(EXPERIMENTAL): Adds support for exception event hooks to enable reporting diagnostic events to monitoring tools.
- feat(EXPERIMENTAL): Adds API for submitting diagnostic events from user code.
- fix: Fixes issue where filtering in insights didn’t work as expected with the provided Dockerfile.
- fix: Fixes an issue so that `name` is now a supported value in Enum models.
- fix: Removes debug prints from generated client code.
- fix: Fixes issue where server-only relation fields didn’t enforce the relation as optional.
- fix: Fixes crash when generator processes model many(`List`) relations without generics.
- fix: Harmonizes local and global cache miss behavior to ensure proper cache miss handling.
- fix: Returns a generic error message for internal server errors in web server routes.
- fix: Adds doc comments to all generated model methods.
- fix: Fixes issue with relative imports generating backwards slashes on Windows.
- fix: Fixes crash in `create-migration` when server folder is renamed.
- fix: Fixes issue where table renaming caused migrations that couldn’t be applied.

## 2.3.1
- fix: Resolved an issue where database exceptions failed to generate informative `toString` messages.
- fix: Improves performance of HTTP request body parsing for both endpoints and the web server.

## 2.3.0
- feat: Adds support for transaction isolation levels.
- feat: Adds typed interface for transaction savepoints.
- feat: Adds support for endpoint definition placement anywhere in server's `src` directory.
- feat: Adds support for model definitions placement anywhere in server's `src` directory.
- fix: Adds additional diagnostic information to database query exceptions.
- fix: Resolved an issue that caused premature closure of method stream websocket connections.
- fix: Improves message transmission guarantee in method streams.

## 2.2.2
 - fix: Fixes possible import issue in generated code when the same model name is used in different modules.

## 2.2.1
 - fix: Fixes an issue where invalid Dart import paths would be generated on Windows.

## 2.2.0
 - feat: Improves Serverpod startup and lifecycle events logging.
 - feat: Adds full support for testing framework.
 - feat: Adds configuration for controlling log output location.
 - feat: Adds support for signing out a user from a single device.
 - feat: EXPERIMENTAL. Adds support for inheritance in models.
 - feat: EXPERIMENTAL. Adds support for sealed classes in models.
 - fix: Only reports invalid Dart endpoint definition files when using `--watch`.
 - fix: Uses direct model import when protocol files are analyzed.
 - fix: Removes redundant file collection from code generation.
 - fix: Fixes error in `serverpod generate` when a `Session` is set as a named required parameter.
 - fix: Responds with 400 when throwing serializable exceptions.
 - fix: Correctly removes account requests after an account is created (auth module).
 - fix: Passes `String` instead of `Error` object to logger in `session.close`.
 - fix: Replaces `null` assert with error check in `WebWidget`.

## 2.1.5
 - feat: EXPERIMENTAL. Adds testing framework. [docs](https://docs.serverpod.dev/next/concepts/testing/get-started)
 - fix: Correctly handles method and endpoint streams for modules.
 - fix: Correctly handles errors in method streams.

## 2.1.4
 - feat: Adds detailed reporting for schema mismatches when checking database consistency.
 - fix: Takes current transaction into account for include queries.
 - fix: Loads passwords from env variables even if the `passwords.yaml` file doesn't exist.
 - fix: Corrects type mismatch in `onTimeout` callback for cancelled subscriptions in `MethodStreamManager.closeAllStreams` method.
 - fix: Correctly returns HTTP 400 error code if parameters passed to Serverpod are incorrect.

## 2.1.3
 - fix: Includes Dockerfile for Serverpod Mini projects.

## 2.1.2
 - fix: Supports updating full user name in auth module.
 - fix: Adds missing transaction parameter in `deleteWhere` query.
 - fix: Correctly preserves non-persisted fields during database insert and update operations.
 - fix: Allows event listeners to remove themselves inside their handler.
 - fix: Correctly checks settings before letting a user change name or image in auth module.

## 2.1.1
 - fix: Posts revoked authentication events locally if Redis is disabled.
 - fix: Uses `dynamic` type for `fromJson` parameter in custom class serialization.

## 2.1.0
 - feat: Adds DevTools extension.
 - feat: Adds support for `Stream` as parameters and return type in endpoint methods.
 - feat: Adds stream subscriptions to message central.
 - feat: Adds support for `willClose` listener on `Session`.
 - feat: Adds support for default values in model files (types supported are `String`, `int`, `double`, `bool`, `DateTime`, `UuidValue`, `Duration`, enums)
 - feat: Adds support for WASM compiled web apps.
 - feat: Endpoint methods with `@Deprecated` annotation are now also annotated in the client.
 - feat: Allows custom password hash generator in `AuthConfig`.
 - feat: Allows rewrite rule in root path in static web directories.
 - feat: Improves error handling in `SignInWithGoogle` by rethrowing exceptions.
 - feat: Adds support for nullable types in `encodeWithType` and `decodeWithType`.
 - feat: Adds `Uuid` identifier to sessions.
 - feat: Supports configuration through environment variables instead of yaml.
 - feat: Models can now be created without fields.
 - feat: Adds ability to register custom environment variables to loaded as passwords.
 - feat: Adds ability to modify `maxFileSize` and expiration time for GCP and AWS buckets.
 - feat: Moves the auth key from the body of the request to the HTTP header in endpoint methods.
 - feat: When sending a HTTP 400 Bad Request error message to the client, an error message may now be included in the client side exception.
 - fix: Allows Serverpod defined models to be encoded and decoded with type.
 - fix: Allows AWS deployments to update Dart version.
 - fix: Fixes top error handling on server's request handler to ensure proper error boundary.
 - fix: Fixes `copyWith` method for nested `List` and `Map` in models.
 - fix: Fixes Dart version and other issues in AWS deployment templates.
 - fix: Improved error message if there are missing tables.
 - fix: Better error message if an error occurs when parsing the config files in CLI.
 - fix: Adds validation of custom class names to look for potential collisions.
 - fix: Only considers positional `Session` parameter when validating endpoint method.
 - fix: Updates example documentation. 
 - fix: Before a session is closed, all logging is now awaited.
 - fix: Adds new `WebCallSession` for Relic.
 - fix: Correctly verifies `iss` value for all possible domains in Sign in with Google.
 - fix: Add `methodName` and `endpointName` to base session class.
 - fix: Handles malformed web server URI parameters more gracefully.
 - fix: Uses `text` as `KeyboardType` for validation code in `SignInWithEmailDialog`.
 - fix: Correctly orders logs in Insights.
 - fix: Correctly strips data in serialization of `List` and `Map`.
 - fix: Starts database pool manager on Serverpod instance creation.
 - fix: Adds mechanism for awaiting pending future calls on shutdown.
 - fix: Improvements to websocket lifecycle.
 - fix: Registers cloud storage endpoint for any `storageId` with `db` storage.
 - fix: Adds logging for when when uploads to buckets fail.
 - fix: Removes redundant and non-prefixed `serverpod_serialization` import.
 - fix: Sets the default authentication handler even when the database is disabled.
 - chore: Updates dependencies.

## 2.0.2
- fix: Conditionally imports `HttpStatus` to improve compatibility.
- fix: Improve `encodeForProtocol` method for `List` and `Map` input object types.

## 2.0.1
- fix: Writes websocket errors to stderr.
- fix: Adds missing web socket connection notification on stream closed.
- fix: Sign in with Email dialog can toggle visibility of passwords.
- fix: Allows usage of user related Google API calls in `onUserCreated` callback.
- fix: Disposes streaming connection listener when disposing handler.
- fix: Only notifies listeners when streaming connection status changes.
- fix: Adds ready check for websocket channel.
- fix: Handles bad websocket upgrade requests.
- fix: Makes sign in buttons customizable.
- fix: Exposes getter for `Session` `authenticationKey`.
- fix: `postMessage` in messages now returns `true` if successful.
- fix: Improved Firebase login widget.
- fix: Adds support for inserting models with only an `id` field.
- fix: Throws exception if required fields are missing when parsing config files.
- fix: Adds explicit exception types for client side exceptions.
- fix: Correctly sets offset and length when encoding `ByteData` for database.
- fix: Removes endpoint to validate validation code.
- fix: Replaces asserts in auth module with throws and logs.
- fix: Changes default values in auth config.
- fix: Removes password reset verification code on usage attempt.
- fix: Stops web server when shutdown method is called.
- chore: Removes dependency to unsupported `firebase_admin` package.
- chore: Bumps minimum Dart version to 3.2.0.
- chore: Updates dependencies.

## 2.0.0
- fix: BREAKING. Database delete methods now return removed objects.
- fix: BREAKING. Removes automatic redirect from Relic.
- fix: BREAKING. Removes `SerializationManager` as a parameter from `fromJson` factory constructor.
- fix: BREAKING. Remove allToJson method.
- fix: BREAKING. Makes user name nullable in `UserInfo`.
- fix: BREAKING. Removes deprecated methods.
- fix: BREAKING. Introduces `DatabaseException`.
- fix: BREAKING. Introduces new types for database result sets.
- fix: BREAKING. Updates transaction interface in database.
- fix: BREAKING. Changes `SerializableEntity` mixin into `SerializableModel` interface.
- fix: BREAKING. Removes support for implicit string to expression conversion.
- fix: BREAKING. Marks deprecated yaml keywords as `isRemoved`.
- fix: BREAKING. Move authentication implementaqtions from core to auth module.
- fix: BREAKING. Removes `customConstructor` map from protocol class.
- chore: BREAKING. Updates Postgres library to new major version.
- feat: Adds parameter arguments to unsafe database queries.
- feat: Adds `upgrade` command to Serverpod CLI.
- feat: Introduces `CacheMissHandler` to improve cache API.
- feat: Serverpod mini. Allows running Serverpod without the database.
- feat: Makes email verification code length customizable.
- feat: Adds client entitlements to MacOS after creating Flutter project.
- fix: Improves server only field validation.
- fix: Retrieves and removes future call entries in a single operation.
- fix: toJson now includes all fields of Serverpod Models.
- fix: Maps Dart `int` to `bigint` in database.
- fix: Generates thumbnails in isolates for auth and chat module.
- fix: Improved logging in CLI.
- fix: Changes root file name in modules to follow Dart standards.
- fix: Removes useless stack trace print from database connection check.
- fix: Uses user scopes from `UserInfo` when authenticating in all providers.
- fix: Prevents silencing deserialization exceptions for unmatched class types.
- fix: Removes deprecated `generated` folder from Serverpod's upgrade template.
- fix: Endpoint requests can now respond with 401 or 403 on failed authentication.
- fix: Gives error when enpoint classes have naming conflicts.
- fix: Run `_storeSharedPrefs` in `logOut` method to preserve state.
- fix: Prints streaming message handler exceptions to console.
- chore: Bumps minimum required Dart version to 3.1.
- docs: Corrects spelling mistakes.
- docs: Improved documentation for chat module.

## 1.2.7
- fix: Spelling fix in UserAuthentication.
- fix: Prevents crash when web or template directory is missing (webserver).
- fix: Removes server only fields from client protocol deserialization.
- fix: Improved error messages in email authentication.
- fix: Minor log fixes.
- fix: Prevents generating empty endpoints variable when no endpoints are defined.
- fix: Adds Docker support for x86 architectures.
- fix: Adds timestamps to `generate --watch` command.
- chore: Updates dependencies.

## 1.2.6
- feat: Adds missing callbacks when sending chat messages in chat module.
- fix: Updates password hash algorithm for email authentication. [Security Advisories](https://github.com/serverpod/serverpod/security/advisories)
- fix: Improves client certificate security. [Security Advisories](https://github.com/serverpod/serverpod/security/advisories)
- fix: Fixes issue when passing empty set in `inSet` and `notInSet`.
- fix: Fixes issue with incorrect line breaks in CLI.

## 1.2.5
- fix: Custom classes respect nullable configuration.

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
- fix: Restrict fields with scopes other than all to be nullable.
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
- fix: Ignores all null fields in JSON map serialization.
- fix: Improved error message if port is in use when starting server.
- chore: Bumps `vm_service` version to support latest version.

## 1.2.0
This is a summary of the new features in version 1.2.0. For the full list, please refer to the [commits](https://github.com/serverpod/serverpod/commits/main/) on Github. Instructions for updating from 1.1 of Serverpod is available in our documentation [here](https://docs.serverpod.dev/upgrading/upgrade-to-one-point-two).

### Main new features and fixes
- feat: Adds official support for Windows.
- feat: Adds Visual Studio Code extension.
- feat: Syntax highlighting in model files.
- feat: Adds LSP server for analyzing model files.
- feat: CLI automatically detects modules without the need to modify the generator file.
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
- fix: Handles invalid return types when parsing endpoint methods.
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
- chore: Fixes deprecated methods.
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
- fix: Only report duplicated and invalid negations once.
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
- feat: Adds serializable exceptions that can be passed from the server to the client.
- feat: Adds `serverOnly` option to yaml-files, which is set to true will prevent the code to be generated for the client.
- feat: Support for `UUID` in serialization.
- feat: New supported static file types in Relic.
- feat: Allows endpoints in sub directories.
- feat: Support for GCP Cloud Storage.
- feat: Support for connecting to Postgres through a UNIX socket.
- feat: Adds database maintenance methods to Insights APIs (still experimental and API may change).
- docs: Improved documentation.
- fix: Better output on startup to aid in debugging connectivity issues.
- fix: Prevents self referencing table to cause `serverpod generate` to hang.
- fix: Adds email from Firebase to UserInfo in auth module.
- fix: Don't print stack trace when Google signin disconnect fails.
- fix: Return bool from `SessionManager.initialize()` to indicate if server was reached.
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
