# Callable endpoints

Each class contains callable functions that will call a function on the server side. The classes are accessible via the Serverpod client you have created in your flutter app. The name of the module is defined in your `config/generator.yaml` file in the server project.

```yaml
modules:
  <module_name>:
    nickname: <nick>
```

The name "EndpointClass" where Class is your class name will have the "Endpoint" part stripped when the client is code generated. When accessing you can simply use the class name in lowercase.

Example usage:

```dart
//Authenticate with email.
client.modules.auth.email.authenticate(email, password)

//Generic format.
client.modules.<nick>.<class>.<function>(...)
```

Please see the full official documentation [here](https://docs.serverpod.dev)