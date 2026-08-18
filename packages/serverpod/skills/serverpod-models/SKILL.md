---
name: serverpod-models
description: Define Serverpod data models in YAML (.spy.yaml) — fields, defaults, database tables, relations, enums, exceptions. Use when creating or editing .spy.yaml files. To query the generated ORM instead, use serverpod-database.
---

# Serverpod Models

Models are defined in `.spy.yaml` files anywhere under server `lib/`. They generate Dart classes for server and client, and optionally database tables.

After each change to models, ensure that the code is generated (automatically when a `serverpod start` is running or manually with `serverpod generate`). If models with `table` have changed, the database schema must be updated following the [migration workflow](../serverpod-migrations/SKILL.md).

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

Add `table` for a database table + ORM:

```yaml
class: Company
table: company
fields:
  name: String
  foundedDate: DateTime?
```

## Default values

- `default=` sets the value on both the Dart model and the database column.
- `defaultModel=` sets it only on the Dart model (used when the object is created in Dart).
- `defaultPersist=` sets it only on the database column (requires the field to be nullable in Dart, unless it is the `id`).

```yaml
class: Post
table: post
fields:
  title: String, default='Untitled'
  createdAt: DateTime, default=now
  publishedAt: DateTime?, defaultPersist=now
  externalId: UuidValue, default=random_v7
  views: int, default=0
  isPublic: bool, default=false
```

`now` (DateTime), `random`/`random_v7` (UuidValue), and quoted literals are supported. A field with a default does not need to be passed to the constructor.

## Custom id types

The `id` field is `int` with a `serial` default unless declared explicitly. Declare it to opt into UUID primary keys:

```yaml
class: Company
table: company
fields:
  id: UuidValue?, defaultPersist=random_v7  # database generates the id
  name: String
```

- `defaultPersist=random_v7` — the database generates the id on insert (`random` for v4).
- `defaultModel=random_v7` — Dart generates the id when the object is created, so it is known before insert.
- `id: int?, defaultPersist=serial` — the explicit form of the default behavior.

Relations to a model with a custom id type use the same type on the foreign key field.

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
    nulls_distinct: false  # PostgreSQL only, treats NULLs as equal
```

Field-level `unique` auto-generates a btree unique index:

```yaml
fields:
  tenantId: int
  category: String
  # single-column unique index
  email: String, unique
  # composite unique index on (category, value)
  value: String, unique(per=category)
  # composite unique index on (category, tenantId, value)
  amount: int, unique(per=[category, tenantId])
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

**Referential actions:** `relation(onDelete=Cascade)` and `relation(onUpdate=...)` map to the SQL foreign key actions (`Cascade`, `SetNull`, `SetDefault`, `Restrict`, `NoAction`). `SetNull` requires a nullable foreign key (a nullable object relation field, or `relation(optional)`). Add `deferrable` (or `deferred` for initially deferred) to check the constraint at the end of the transaction instead of per statement.

Querying: `include` for eager loading, `includeList` with `where`/`orderBy`/`limit`/`offset` for list relations. `attach`/`detach` for managing relations.

## Backward compatibility

To keep backward compatibility, do not change or remove fields in serialized classes used by clients. Add new fields only if nullable or with a default value, so older clients that don't send the field still work.

## Reference files

- [`references/client-side-database.md`](references/client-side-database.md) — the `database:` keyword, generating tables on the client.
- [`references/custom-serialization.md`](references/custom-serialization.md) — using hand-written or Freezed classes as model types via `extraClasses`.
