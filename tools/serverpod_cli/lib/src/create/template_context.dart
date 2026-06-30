import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';

/// Context containing values for rendering templates.
class TemplateContext {
  TemplateContext({
    this.template = ServerpodTemplateType.fullstack,
    this.auth = false,
    this.redis = false,
    this.postgres = false,
    this.sqlite = false,
    this.website = false,
    this.webapp = false,
    this.flutterApp = false,
    this.ides = const [],
  });

  /// The template type.
  final ServerpodTemplateType template;

  /// True if auth is enabled.
  final bool auth;

  /// True if redis is enabled.
  final bool redis;

  /// True if postgres is enabled.
  final bool postgres;

  /// True if sqlite is enabled.
  final bool sqlite;

  /// True if website is enabled.
  final bool website;

  /// True if web app is enabled.
  final bool webapp;

  /// True if companion Flutter app is enabled.
  final bool flutterApp;

  /// The configured IDEs.
  final List<TemplateIde> ides;

  /// True if docker is enabled.
  bool get docker => postgres || redis;

  /// True if a database is enabled.
  bool get database => postgres || sqlite;

  /// True if webserver is enabled.
  bool get webserver => website || webapp;

  Map<String, bool> toMustacheMap() {
    return {
      'auth': auth && postgres, // auth requires postgres
      'database': database,
      'docker': docker,
      'postgres': postgres,
      'redis': redis,
      'sqlite': sqlite,
      'webapp': webapp,
      'webserver': webserver,
      'website': website,
      'flutterApp': flutterApp || template == ServerpodTemplateType.fullstack,
    };
  }
}
