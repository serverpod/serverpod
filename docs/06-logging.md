# Logging
Serverpod uses the database for storing logs; this makes it easy to search for errors, slow queries, or debug messages. To log custom messages during the execution of a session, use the `log` method of the `session` object. When the session is closed, either from successful execution or by failing from throwing an exception, the messages are written to the log. By default, session log entries are written for every completed session.

```dart
session.log('This is working well');
```

You can also pass exceptions and stack traces to the `log` method or set the logging level.

```dart
session.log(
  'Oops, something went wrong',
  level: LogLevel.warning,
  exception: e,
  stackTrace: stackTrace,
);
```

Log entries are stored in the following tables of the database: `serverpod_log` for text messages, `serverpod_query_log` for queries, and `serverpod_session_log` for completed sessions. Optionally, it's possible to pass a log level with the message to filter out messages depending on the server's runtime settings.

The Serverpod GUI is coming soon, which makes it possible to easily read, search, and configure the logs.
