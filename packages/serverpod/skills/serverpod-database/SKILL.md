---
name: serverpod-database
description: Serverpod ORM with PostgreSQL or SQLite — CRUD, filters, sorting, pagination, relations, transactions, raw SQL, client-side database. Use when querying the database or working with relations.
---

# Serverpod Database

Serverpod generates ORM code for models with `table` in `.spy.yaml`. PostgreSQL is the default production database; SQLite is also supported for projects/tests that configure the database on `config/<runMode>.yaml` with `database.filePath: <path>`.

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
- Vector: distance operators (`distanceCosine`, `distanceL2`) for similarity search (PostgreSQL only).

## Sorting and pagination

- Sort: `orderBy: (t) => t.column` (ascending default); `orderBy: (t) => t.column.desc()` for descending
- Multiple: `orderByList: (t) => [t.name.desc(), t.id.asc()]`
- Sort on relation: `orderBy: (t) => t.ceo.name`; on count: `orderBy: (t) => t.employees.count()`
- Pagination: `limit` + `offset` for offset-based; cursor-based: `where: (t) => t.id > lastId` with `orderBy: (t) => t.id` and `limit`

## Relations (include, attach, detach)

Fetch related objects with `include`:

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

Models with object relations also have dedicated methods for attach/detach:

```dart
await Company.db.attachRow.employees(session, company, employee);
await Company.db.attach.employees(session, company, [e1, e2]);
await Company.db.detachRow.employees(session, employee);
```

Objects being attached/detached must have `id` set (typically fetched previously from the database).

## Transactions

```dart
await session.db.transaction((tx) async {
  await Company.db.insertRow(session, company, transaction: tx);
  await OtherModel.db.updateRow(session, other, transaction: tx);
});
```

Use `tx` for all DB calls inside the transaction.

## Row locking

Requires a transaction. Pass `lockMode` and `transaction` to `find`/`findFirstRow`/`findById`:

- `LockMode.forUpdate` (exclusive), `forNoKeyUpdate`, `forShare`, `forKeyShare`
- `LockBehavior.wait` (default), `noWait` (throw), `skipLocked` (skip, good for job queues)
- Lock without reading: `Company.db.lockRows(session, where: ..., lockMode: ..., transaction: tx)`

On SQLite, trying to lock rows will be a no-op, since it only supports one write transaction at a time.

## Runtime parameters

Set Postgres params globally: `runtimeParametersBuilder: (params) => [params.searchPaths(['my_schema', 'public'])]` at Serverpod init. Per-transaction: `await tx.setRuntimeParameters(...)`. Use for search path, vector index options, or custom `MapRuntimeParameters`. Cannot set at session level due to connection pooling.

## Raw SQL

For running raw SQL queries, use one of the following methods:

```dart
late DatabaseResult result;
result = await session.db.unsafeQuery(query, parameters: parameters);
result = await session.db.unsafeSimpleQuery(query);

late int rowsAffected;
rowsAffected = await session.db.unsafeExecute(query, parameters: parameters);
rowsAffected = await session.db.unsafeSimpleExecute(query);
```

Prefer ORM for standard CRUD, and parameterize user input instead of string-concatenating SQL.

## Client-side database

When at least one model has `database: client` or `database: all`, the generated `Client` class will have a `createSession` method that returns a `ClientDatabaseSession` for the SQLite database file. On Flutter, open the database doing:

```dart
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:my_project_client/my_project_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set the client URL to the server URL
  final client = Client(clientUrl);

  // Resolve the database path
  final path = await resolveDatabasePath('app.db');

  // Store the session in your state manager to later use on database operations.
  final session = await client.createSession(path, isDebugMode: kDebugMode);
}

Future<String> resolveDatabasePath(String fileName) async {
  if (kIsWeb) return fileName;
  final dir = await getApplicationSupportDirectory();
  return p.join(dir.path, fileName);
}
```

Note that the `serverpod_database` package will have to be added as dependency on the client package.
