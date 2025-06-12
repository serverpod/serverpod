/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_email_account_server/serverpod_auth_email_account_server.dart'
    as _i2;
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart'
    as _i3;
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart'
    as _i4;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i5;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    modules['serverpod_auth_email_account'] = _i2.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_profile'] = _i3.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_session'] = _i4.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_user'] = _i5.Endpoints()
      ..initializeEndpoints(server);
  }
}
