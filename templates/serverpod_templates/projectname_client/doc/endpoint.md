# Callable endpoints

Each class contains callable functions that will call a function on the server side. These are normally defined in the `endpoint` directory in your server project. This client sends requests to these endpoints and returns the result.

Example usage:

```dart
//How to use ExampleEndpoint
client.example.hello("world!");

//Generic format.
client.<class>.<function>(...);
```

Please see the full official documentation [here](https://docs.serverpod.dev)
