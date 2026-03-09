---
name: serverpod-models
description: Define Serverpod data models in YAML (.spy.yaml), serialization, database tables, relations, enums, and exceptions. Use when creating or editing models, database schema, .spy.yaml files, or Serverpod ORM entities.
---

# Serverpod Models

Models are defined in `.spy.yaml` files anywhere under server `lib/`. They generate Dart classes for server and client, and optionally database tables. Run `serverpod generate` after changes.

## Basic class

```yaml
class: Company
fields:
  name: String
  foundedDate: DateTime?
  employees: List<Employee>
```

Field types: `bool`, `int`, `double`, `String`, `Duration`, `DateTime`, `ByteData`, `UuidValue`, `Uri`, `BigInt`, generated classes/enums/exceptions, `List<T>`, `Map<K,V>`, `Set<T>`, `Record`. Use `?` for nullable.

## Required fields

```yaml
class: Person
fields:
  name: String
  nickname: String?, required
```

## Database table

Add `table` for PostgreSQL table + ORM:

```yaml
class: Company
table: company
fields:
  name: String
  foundedDate: DateTime?
```

Run `serverpod create-migration` after schema changes, start server with `--apply-migrations`.

## Scope

- **Server-only class:** `serverOnly: true`
- **Per-field:** `scope=serverOnly`, `scope=none` (default `all`)
- **Non-persisted field:** `!persist` (not stored in DB)
- **JSON key alias:** `jsonKey=display_name`

## Immutable classes

`immutable: true` — final fields, `==`, `hashCode`, `copyWith`.

## Inheritance

- `extends: ParentClass` — child inherits parent fields. Only one class in hierarchy has `table`.
- `sealed: true` — abstract sealed hierarchy for exhaustive subtypes. No `table` on sealed class.

If parent is `serverOnly`, children must be too. Children cannot redefine parent fields.

## Enums

```yaml
enum: Status
values:
  - pending
  - active
  - completed
```

Default serialization: `byName`. Set `serialized: byIndex` to use index.

## Exceptions

Use `exception:` instead of `class:` for serializable exceptions. Same field types as classes; supports `default` and `defaultModel`. Uncaught exceptions become generic 500 errors on the client; only serializable exceptions send their data.

```yaml
exception: MyException
fields:
  message: String
  errorType: MyEnum
```

Throw on server, catch on client:

```dart
// Server
throw MyException(message: 'Failed', errorType: MyEnum.thingyError);

// Client
try {
  await client.example.doThingy();
} on MyException catch (e) {
  print(e.message);
}
```

Serializable exceptions can also be sent over streams (both directions; the stream closes after). Do not put sensitive data in exception fields — they are sent to the client.

## Indexes

```yaml
indexes:
  company_name_idx:
    fields: name
    unique: true
```

## Relations

**One-to-one** (FK with unique index):

- ID field: `addressId: int, relation(parent=address)` + unique index on `addressId`
- Object field: `address: Address?, relation` (generates `addressId`)
- Optional: `relation(optional)` for nullable FK; `relation(field=customId)` for custom FK name
- Bidirectional: same `relation(name=...)` on both sides, `field=` on FK side

**One-to-many:**

- "One" side: `employees: List<Employee>?, relation`
- "Many" side: `companyId: int, relation(parent=company)` (no unique index)
- Bidirectional: `relation(name=company_employees)` on both sides

**Many-to-many:** Use a join table model with two relation fields.

Querying: `include` for eager loading, `includeList` with `where`/`orderBy`/`limit`/`offset` for list relations. `attach`/`detach` for managing relations.

## Workflow

1. Add/edit `.spy.yaml` under server `lib/`
2. `serverpod generate`
3. If table/index changed: `serverpod create-migration`, start server with `--apply-migrations`

## Backward compatibility

To keep backward compatibility, do not change or remove fields in serialized classes used by clients. Add new fields only if nullable or with a default value, so older clients that don't send the field still work.

## Custom serialization

To use serializable models not in YAML: implement `toJson()`, `fromJson`, `copyWith()`. Register in `config/generator.yaml` under `extraClasses` with full URI (e.g. `package:my_shared/my_shared.dart:ClassName`). Both server and client must depend on the package. Freezed classes with `fromJson` work the same way. Implement `ProtocolSerialization` with `toJsonForProtocol()` to omit fields when sending to client.
