# Serialization
Serverpod makes it easy to generate serializable classes that can be passed between server and client or used to communicate with the database. The structure for the classes is defined in yaml-files in the protocol directory. Run `serverpod generate` to build the Dart code for the classes and make them accessible to both the server and client.

Here is a simple example of a yaml-file defining a serializable class:

```yaml
class: Company
fields:
  name: String
  foundedDate: DateTime?
  employees: List<Employee>
```

Supported types are `bool`, `int`, `double`, `String`, `DateTime`, and other serializable classes. You can also use lists of objects. Null safety is supported. Once your classes are generated, you can use them as parameters or return types to endpoint methods.

__Note:__ There is not yet support for `Map` or lists of lists. These are planned to be added in a future version.
