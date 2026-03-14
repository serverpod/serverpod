# Decoupling of the CLI and Serverpod

## Summary

The dependency between the `serverpod_cli` and the `serverpod` packages is not explicit, since they don’t depend on one another through the `pubspec.yaml` files. Instead, this is a hidden dependency due to the analyzer and SQL generator on the `serverpod_cli` expecting a specific structure of the used-defined classes that uses the `serverpod` dependency.

Some elements in common are declared in the `serverpod_shared` package, such as the config parser and config objects, the annotations, some constants, enums and exceptions, etc. But others, such as the base `Endpoint` and  `FutureCall` classes, exist on the `serverpod` package and are analyzed on the `serverpod_cli` by element name.

```dart
// Example from the future call analyzer
if (parentClass is ClassElement &&
    parentClassName != null &&
    parentClassName != 'FutureCall') {  // <-- Reference of the class by name
  var parentFilePath = parentClass.library == element.library
      ? filePath
      : parentClass.library.identifier;
  ...
}
```

A practical example of this dependency is the implementation of the generated type-safe API for future calls. There were changes on both the `serverpod` package and the `serverpod_cli` package, to support it, even though no code was shared between them.

But the CLI should actually be a shell responsible by the UX of interacting with Serverpod, and not be responsible by the implementation of the framework.

## Implementation proposal

For the CLI to become this UX shell, all parts of the CLI that are linked to the `serverpod` package should be moved to a separate package that will have a stable API, and the `serverpod_cli` should invoke this API without ever importing the package.

This would move the implicit dependency to between the `serverpod_cli` and this interface package - that we will now call `serverpod_generator`. Such package would keep the same versioning as `serverpod`, making it a safe proxy for the `serverpod` version. Ensuring the correct version range that a given `serverpod_cli` would support of the `serverpod_generator` would have to be enforced through tests and CI pipelines, which might be already covered by the `melos downgrade` tests.

### What should be moved to `serverpod_generate`

Mainly, the core execution of all commands. Below are the folders from the `serverpod_cli` to move:

- `analyzer`: Analyzing a project is strictly tied to the features supported by the installed version, so it must be versioned together with the `serverpod` package.
    - The `ProtocolDefinition` itself, together with the other `*Definition` classes, are part of the analyzer that changes over time to support new features on `serverpod`.  Since it is only used for the `generate` command, it is not a problem if it lives inside the `serverpod_generator`.
- `create`: Templates are tied to the `serverpod` version, frequently adding features as they are released or improving the UX based on changes to the framework.
- `database`: The SQL generation for migrations depend on the database-related `serverpod` models (which are being moved to a new `serverpod_database` package).
    - There won’t be a direct `serverpod` dependency, but an indirect dependency since `serverpod` will depend strictly on the `serverpod_database` version. Ideally, the SQL generation for migrations should also be moved to the `serverpod_database` package.
- `downloads`: Templates are already stored in a versioned directory under `~/.serverpod`, so the only change would be to download them from the `serverpod_generator` package.
- `generator`: For the same reasons as the `analyzer`, it produces code that depends strictly on the version of the `serverpod` package - a lot of code extend/implement `serverpod` classes.

### What stays in the `serverpod_cli`

The interface for invoking the commands. Since a version of the `serverpod_cli` can have newer features than an installed `serverpod` package for a given project, when running any command we should check the version and throw if a feature is being used on a version previous to its implementation.

To facilitate the version restriction on each command/option, we should build a utility that simplifies this process. An annotation-based experience would be very nice, since the same syntax would be valid for commands, options or whatever we need to restrict to specific version ranges.

Below are all commands that stay on the package as interfaces to invoke the actual execution by the `serverpod_generator` package:

- Create (repair) migration commands.
- Create project command.
- Generate command.
- Language server.
- Upgrade serverpod.
- Version command.
- Other utility internal commands, such as analyze and generate pubspecs.

### Ensuring performance

Although it could be possible to invoke `dart run path/to/serverpod/generator` on the project folder to use the installed version, it would be very slow, since the dart process takes ~10 seconds to start. So we need a compiled binary for every installed version.

We could reuse the `~/.serverpod` folder to also store this binary together with the templates. To avoid bloating the user machine, we could have another file storing the last time such version was accessed to perform a regular cleanup when running new versions for the first time.

The correct version for each project could be defined by getting the `serverpod` version from the `projectname_server/pubspec.yaml` file.

## Motivation

The main motivations for this changes are:

1. Users would be able to run multiple serverpod versions on the same machine without having to switch the CLI version for each.
2. It would be possible to release improvements to the UX on the `serverpod_cli` without having to push upgrades to users projects.
3. It would pave the way for bundling the `scloud` inside the `serverpod_cli` and unify the experience of building and deploying Serverpod projects.
