---
name: serverpod-modules
description: Create and use Serverpod modules — adding modules, generator.yaml nicknames, model references, creating custom modules. Use when working with modules or shared server/client code.
---

# Serverpod Modules

Modules are reusable Serverpod packages with server, client, and optionally Flutter code in their own endpoint/model namespaces.

## Adding a module

**Server:** Add module server package to `pubspec.yaml` (e.g. `serverpod_auth_idp_server: 3.x.x`). Optionally declare in `config/generator.yaml`:

```yaml
modules:
  serverpod_auth_idp:
    nickname: auth
```

Then `dart pub get`, `serverpod generate`. If the module adds tables: `serverpod create-migration` and apply (start server with `--apply-migrations`).

**Client:** Add module client package (e.g. `serverpod_auth_idp_client: 3.x.x`).

**Flutter:** Add module Flutter package if provided (e.g. `serverpod_auth_idp_flutter: 3.x.x`).

Keep Serverpod and module versions aligned.

## Referencing module types in models

```yaml
class: MyClass
fields:
  userInfo: module:serverpod_auth_idp:AuthUser
  # Or with nickname:
  userInfo: module:auth:AuthUser
```

Run `serverpod generate` after changes.

## Creating a custom module

```bash
serverpod create --template module my_module
```

Creates server + client packages. Add Flutter package if needed: `flutter create --template package my_module_flutter`. Set `type: module` in `config/generator.yaml`. Prefix table names (e.g. `my_module_orders`) to avoid clashes.
