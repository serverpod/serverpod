import 'package:serverpod_cli/src/create/ide.dart';

/// Context containing values for rendering templates.
class TemplateContext {
  TemplateContext({
    this.auth = false,
    this.redis = false,
    this.postgres = false,
    this.sqlite = false,
    this.web = false,
    this.ides = const [],
  });

  /// True if auth is enabled.
  final bool auth;

  /// True if redis is enabled.
  final bool redis;

  /// True if postgres is enabled.
  final bool postgres;

  /// True if sqlite is enabled.
  final bool sqlite;

  /// True if web is enabled.
  final bool web;

  /// The configured IDEs.
  final List<TemplateIde> ides;

  /// True if docker is enabled.
  bool get docker => postgres || redis;

  /// True if a database is enabled.
  bool get database => postgres || sqlite;

  Map<String, bool> toJson() {
    return {
      'auth': auth & postgres, // auth requires postgres
      'redis': redis,
      'postgres': postgres,
      'sqlite': sqlite,
      'web': web,
      'docker': docker,
      'database': database,
    };
  }
}
