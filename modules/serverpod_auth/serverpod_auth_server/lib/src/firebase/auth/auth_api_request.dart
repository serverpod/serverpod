import 'dart:convert';

import 'package:serverpod_auth_server/src/firebase/app.dart';
import 'package:serverpod_auth_server/src/firebase/auth/user_record.dart';
import 'package:http/http.dart' as http;

class AuthRequestHandler {
  final App app;
  static AuthRequestHandler Function(App app) factory =
      (app) => AuthRequestHandler._(app);

  factory AuthRequestHandler(App app) => factory(app);

  AuthRequestHandler._(this.app);

  /// Looks up a user by uid.
  Future<UserRecord> getAccountInfoByUid(String uid) async {
    if (!_isUid(uid)) {
      throw Exception(
        'The uid must be a non-empty string with at most 128 characters.',
      );
    }
    return _getAccountInfo(localId: [uid]);
  }

  bool _isUid(String? uid) {
    return uid != null && uid.isNotEmpty && uid.length <= 128;
  }

  Future<UserRecord> _getAccountInfo({
    List<String>? localId,
  }) async {
    var response = await http.post(
      Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=${app.options.apiKey}',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'localId': localId}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'There is no user record corresponding to the provided identifier.',
      );
    }

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    List<dynamic> users = jsonResponse['users'];
    Map<String, dynamic> user = Map.from(users.first);

    return UserRecord.fromJson(user);
  }
}
