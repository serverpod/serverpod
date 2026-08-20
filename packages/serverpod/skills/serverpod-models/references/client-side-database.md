# Client-side database models

Reference for the [Serverpod Models](../SKILL.md) skill.

Models with the `table` keyword can also generate a client-side database with the `database` keyword:

```yaml
class: Company
table: company
database: client
```

| Value | Description |
| ------- | ----------- |
| `server` | Generates tables only on the server, and a non-table model on the client package (default). |
| `client` | Generates tables only on the client, and a non-table model on the server package. |
| `all` | Generates table models on both server and client. |

For how to use the client-side database, see the [Serverpod Database](../../serverpod-database/SKILL.md#client-side-database) skill.
