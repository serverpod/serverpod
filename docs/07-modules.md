# Modules
Serverpod is built around the concept of modules. A Serverpod module is similar to a Dart package, but it contains both server and client code, as well as Flutter widgets. A module contains its own name space for endpoints and methods to minimize any conflicts between modules.

Examples of modules are the `serverpod_auth` module and the `serverpod_chat` module that both are maintained by the Serverpod team.

## Adding a module to your project
To add a module to your project you need to include the server and client/Flutter packages to your project's `pubspec.yaml` files and to add an entry to your `config/generator.yaml` file.

For example, to add the `serverpod_auth` module to your project you need to add `serverpod_auth_server` to your server's `pubspec.yaml`:

```yaml
dependencies:
  serverpod_auth_server: ^0.9.5
```

In your `config/generator.yaml` add the `serverpod_auth` module and give it a `nickname`. The nickname will determine how you reference the module from the client.

```yaml
modules:
  serverpod_auth:
    nickname: auth
```

Finally, you need to run `pub get` and `serverpod generate` from your server's directory (e.g. mypod_server) to add the module to your protocol.

```sh
dart pub get
serverpod generate
```

In your app, add the corresponding dart or Flutter package(s) to your `pubspec.yaml`.

```yaml
dependencies:
  serverpod_auth_shared_flutter: ^0.9.5
  serverpod_auth_google_flutter: ^0.9.5
  serverpod_auth_apple_flutter: ^0.9.5
```

## Creating custom modules
With the `serverpod create` command it is possible to create new modules for code that is shared between projects or that you want to publish to pub.dev. To create a module instead of a server project, pass `module` to the `--template` flag.

```sh
serverpod create --template module my_module
```

The create command will create a server and a client Dart package. If you also want to add custom Flutter code, use `flutter create` to create a package.

```sh
flutter create --template package my_module_flutter
```

In your Flutter package you most likely want to import the client libraries created by `serverpod create`.
