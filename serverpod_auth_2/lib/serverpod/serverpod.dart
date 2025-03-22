import 'package:serverpod_auth_2/serverpod/api_server.dart';
import 'package:serverpod_auth_2/serverpod/relic.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_info_repository.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session_repository.dart';

/// A demo "server" instance which provides the basic building blocks of the endpoints and the default user auth module
class Serverpod {
  var relic = RelicServer();

  var api = ApiServer();

  // TODO: If this were typed to the project's user info, we'd need to provide a way to create that instance with it
  var userInfoRepository = UserInfoRepository();
  final SessionRepository userSessionRepository = UserSessionRepository();
}
