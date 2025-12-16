# Callable endpoints

Each class contains callable methods that will call a method on the server side. These are normally defined in the `endpoint` directory in your server project. This client sends requests to these endpoints and returns the result.

Example usage:

```dart
// How to use GreetingEndpoint.
client.greeting.hello("world!");

// Generic format.
client.<endpoint>.<method>(...);
```

Please see the full official documentation [here](https://docs.serverpod.dev)
