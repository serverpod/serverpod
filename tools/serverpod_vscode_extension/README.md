# Serverpod

[Serverpod](https://serverpod.dev) is a next-generation app and web server, built for the Flutter community. It allows you to write your server-side code in Dart, automatically generate your APIs, and hook up your database with minimal effort. Serverpod is open-source, and you can host your server anywhere.

## Key features

Syntax highlighting in model files.

![Syntax highlighting](https://github.com/serverpod/serverpod/blob/main/tools/serverpod_vscode_extension/assets/images/syntax-highlighting.png?raw=true)

Real-time diagnostics show errors in model files as you type.

![Diagnostics](https://github.com/serverpod/serverpod/blob/main/tools/serverpod_vscode_extension/assets/videos/diagnostics.gif?raw=true)

Go to definition (CTRL+Click) in model files navigates to the model, enum or field a name refers to, including models from modules and tables referenced through `relation(parent=...)`.

Find references in model files lists where a model, table or field is used. Only model files are searched; usages in Dart code are reported by the Dart language server.

Go to definition on a model class in Dart code also offers its model file. The `Serverpod: Go to Model Definition` command (CTRL+ALT+F12, CMD+ALT+F12 on macOS) jumps straight to it.

## Requirements

You need the Serverpod (^1.2.0) CLI installed in your path for this extension to work. Run the following command in your terminal to install it:

`dart install serverpod_cli`

Note: The Serverpod CLI requires both [Dart and Flutter](https://docs.flutter.dev/get-started/install) to be installed.
