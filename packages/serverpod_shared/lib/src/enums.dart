/// The main role of the server. By default, Serverpod is running as a monolith,
/// but it can also be configured to run as a serverless server, or in
/// maintenance mode where it runs scheduled tasks, such as executing future
/// calls.
enum ServerpodRole {
  /// The server is running as a monolith. This is the default.
  monolith,

  /// The server is running as a serverless server. Use this option if you want
  /// to run the server in a serverless environment, such as AWS Lambda or
  /// Google Cloud Run.
  serverless,

  /// Run the server in maintenance mode. This is used to run scheduled tasks,
  /// such as executing future calls. The server will not accept any requests.
  maintenance,
}

/// The overarching logging mode of the server. This can be set to either
/// [normal] or [verbose]. In [normal] mode, only important messages are logged,
/// which is the default.
enum ServerpodLoggingMode {
  /// Only log important messages.
  normal,

  /// Log all messages, including debugging information.
  verbose,
}
