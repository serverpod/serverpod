import 'package:serverpod/server.dart';

typedef ChatChannelAccessVerificationCallback = Future<bool> Function(
    Session session, int userId, String channel);

class ChatConfig {
  static ChatConfig _config = ChatConfig();

  /// Updates the configuration used by the Auth module.
  static void set(ChatConfig config) {
    _config = config;
  }

  /// Gets the current Auth module configuration.
  static ChatConfig get current => _config;

  late final ChatChannelAccessVerificationCallback channelAccessVerification;
  final bool allowUnauthenticatedUsers;

  ChatConfig({
    ChatChannelAccessVerificationCallback? channelAccessVerification,
    this.allowUnauthenticatedUsers = false,
  }) {
    this.channelAccessVerification =
        channelAccessVerification ?? (session, userId, channel) async => true;
  }
}
