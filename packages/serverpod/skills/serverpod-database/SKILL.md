---
name: serverpod-database
description: Serverpod ORM with PostgreSQL — CRUD, filters, sorting, pagination, relations, migrations, transactions, raw SQL. Use when querying the database, writing migrations, or working with relations. Also include serverpod-models skill if you need to change models.
---

# Serverpod Database

PostgreSQL via ORM. Models with `table` in `.spy.yaml` get generated ORM code.

## CRUD

```dart
var company = Company(name: 'Serverpod Inc.', foundedDate: DateTime.now());
company = await Company.db.insertRow(session, company);
var stored = await Company.db.findById(session, company.id);
company = company.copyWith(name: 'New Name');
await Company.db.updateRow(session, company);
await Company.db.deleteRow(session, company);
```

## Filters

Fluent filter API via `where` callback with table descriptor `t`:

```dart
var activeCompanies = await Company.db.find(session,
  where: (t) => t.name.ilike('a%') & (t.foundedDate > DateTime(2020)));
```

- Equality: `t.column.equals(value)`, `t.column.notEquals(value)`
- Comparison (int/double/Duration/DateTime): `>`, `>=`, `<`, `<=`
- Range: `t.column.between(a, b)`, `notBetween`
- Set: `t.column.inSet(set)`, `notInSet`
- String: `t.column.like('A%')` (case-sensitive), `ilike` (case-insensitive); `%` = any chars, `_` = one char
- Combine: `&` (and), `|` (or), `~` (not); use parentheses for precedence
- Related (one-to-one): `t.address.street.like('%road%')`
- Related (one-to-many): `t.orders.count() > 3`, `t.orders.count((o) => o.itemType.equals('book')) > 3`, `t.orders.none()`, `t.orders.any()`, `t.orders.any((o) => ...)`, `t.orders.every((o) => ...)`
- Vector: distance operators (`distanceCosine`, `distanceL2`) for similarity search

## Sorting and pagination

- Sort: `orderBy: (t) => t.column` (ascending default); `orderDescending: true` for descending
- Multiple: `orderByList: (t) => [Order(column: t.name, orderDescending: true), Order(column: t.id)]`
- Sort on relation: `orderBy: (t) => t.ceo.name`; on count: `orderBy: (t) => t.employees.count()`
- Pagination: `limit` + `offset` for offset-based; cursor-based: `where: (t) => t.id > lastId` with `orderBy: (t) => t.id` and `limit`

## Relations (include, attach, detach)

```dart
var employee = await Employee.db.findById(session, id,
  include: Employee.include(address: Address.include()));

var company = await Company.db.findById(session, id,
  include: Company.include(
    employees: Employee.includeList(
      where: (t) => t.name.ilike('a%'),
      orderBy: (t) => t.name,
      limit: 10,
      includes: Employee.include(address: Address.include()),
    ),
  ));
```

Attach/detach: `Company.db.attachRow.employees(session, company, employee)`, `Company.db.attach.employees(session, company, [e1, e2])`, `Company.db.detachRow.employees(session, employee)`. Objects must have `id` set.

## Transactions

```dart
await session.transaction((tx) async {
  await Company.db.insertRow(tx, company);
  await OtherModel.db.updateRow(tx, other);
});
```

Use `tx` (not the outer `session`) for all DB calls inside.

## Row locking

Requires a transaction. Pass `lockMode` and `transaction` to `find`/`findFirstRow`/`findById`:

- `LockMode.forUpdate` (exclusive), `forNoKeyUpdate`, `forShare`, `forKeyShare`
- `LockBehavior.wait` (default), `noWait` (throw), `skipLocked` (skip, good for job queues)
- Lock without reading: `Company.db.lockRows(session, where: ..., lockMode: ..., transaction: tx)`

## Runtime parameters

Set Postgres params globally: `runtimeParametersBuilder: (params) => [params.searchPaths(['my_schema', 'public'])]` at Serverpod init. Per-transaction: `await tx.setRuntimeParameters(...)`. Use for search path, vector index options, or custom `MapRuntimeParameters`. Cannot set at session level due to connection pooling.

## Migrations

After changing models with `table`/indexes: `serverpod create-migration`, then `dart run bin/main.dart --apply-migrations`. Options: `--force` (override safeguards), `--tag "v1"` (name tag). For scripted apply: `--role maintenance --apply-migrations` (exits with 0 on success). Opt out per table: `managedMigration: false`.

**Repair migrations:** If DB was changed outside migrations: `serverpod create-repair-migration` (options: `--mode production`, `--version <name>`, `--force`, `--tag`). Apply: `--apply-repair-migration`. Runs before normal migrations.

## Raw SQL

Use raw SQL via the session/database API for queries beyond ORM. Prefer ORM for standard CRUD.
