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
