import 'package:serverpod/server.dart';

typedef ChatJoinChannelVerificationCallback = Future<bool> Function(
  Session session,
  int userId,
);

class Chat {}
