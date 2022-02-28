# Database communication
Serverpod makes it easy to communicate with your database using strictly typed objects without a single SQL line. But, if you need to do more complex tasks, you can always do direct SQL calls. You define your database mappings right in the protocol yaml files.

## Database mappings
It's possible to map serializable classes straight to tables in your database. To do this, add the `table` key to your yaml file:

```yaml
class: Company
table: company
fields:
  name: String
  foundedDate: DateTime?
  employees: List<Employee>
```

When running `serverpod generate`, the database schema will be saved in the `generated/tables.pgsql` file. You can use this to create the corresponding database tables.

In some cases, you want to save a field to the database, but it should never be sent to the server. You can exclude it from the protocol by adding the `database` flag to the type.

```yaml
class: UserData
fields:
  name: String
  password: String, database
```

Likewise, if you only want a field to be accessible in the protocol but not stored in the server, you can add the `api` flag. By default, a field is accessible to both the API and the database.

### Database indexes
For performance reasons, you may want to add indexes to your database tables. You add these in the yaml-files defining the serializable objects.

```yaml
class: Company
table: company
fields:
  name: String
  foundedDate: DateTime?
  employees: List<Employee>
indexes:
  company_name_idx:
    fields: name
```

The `fields` key holds a comma-separated list of column names. In addition, it's possible to add a type key (default is `btree`), and a `unique` key (default is `false`).

## Making queries
For the communication to work, you need to have generated serializable classes with the `table` key set, and the corresponding table must have been created in the database.

### Inserting a table row
Insert a new row in the database by calling the insert method of the `db` field in your `Session` object.

```dart
var myRow = Company(name: 'Serverpod corp.', employees: []);
await Company.insert(session, myRow);
```

After the object has been inserted, it's `id` field is set from its row in the database.

### Finding a single row
You can find a single row, either by its `id` or using an expression. You need to pass a reference to the a session in the call. Tables are accessible through generated serializable classes.

```dart
var myCompany = await Company.findById(session, companyId);
```

If no matching row is found, `null` is returned. You can also search for rows using expressions with the `where` parameter. The `where` parameter is a typed expression builder. The builder's parameter, `t`, contains a description of the table which gives access to the table's columns.

```dart
var myCompany = await Company.findSingleRow(
  session,
  where: (t) => t.name.equals('My Company'),
);
```

### Finding multiple rows
To find multiple rows, use the same principle as for finding a single row. Returned will be a `List` of `TableRow`s.

```dart
var companies = await Company.find(
  tCompany,
  where: (t) => t.id < 100,
  limit 50,
);
```
### Updating a row
To update a row, use the `update` method. The object that you update must have its `id` set to a non `null` value.

```dart
var myCompany = await session.db.findById(tCompany, companyId) as Company?;
myCompany.name = 'New name';
await session.db.update(myCompany);
```

### Deleting rows
Deleting a single row works similarly to the `update` method, but you can also delete rows using the where parameter.

```dart
// Delete a single row
await Company.deleteRow(session, myCompany);

// Delete all rows where the company name ends with 'Ltd'
await Company.delete(
  where: (t) => t.name.like('%Ltd'),
);
```

### Creating expressions
To find or delete specific rows, most often, expressions are needed. Serverpod makes it easy to build expressions that are statically type-checked. Columns are referenced using the global table descriptor objects. The table descriptors, `t` are passed to the expression builder function. The `>`, `>=`, `<`, `<=`, `&`, and `|` operators are overridden to make it easier to work with column values. When using the operators, it's a good practice to place them within a set of parentheses as the precedence rules are not always what would be expected. These are some examples of expressions.

```dart
// The name column of the Company table equals 'My company')
t.name.equals('My company')

// Companies founded at or after 2020
t.foundedDate >= DateTime.utc(2020)

// Companies with number of employees between 10 and 100
(t.numEmployees > 10) & (t.numEmployees <= 100)

// Companies that has the founded date set
t.foundedDate.notEquals(null)
```

### Transactions
Docs coming.

### Executing raw queries
Sometimes more advanced tasks need to be performed on the database. For those occasions, it's possible to run raw SQL queries on the database. Use the `query` method. A `List<List<dynamic>>` will be returned with rows and columns.

```dart
var result = await session.db.query('SELECT * FROM mytable WHERE ...');
```
