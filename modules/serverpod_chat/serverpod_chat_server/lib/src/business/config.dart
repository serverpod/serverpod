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
  final bool postMessagesLocallyOnly;

  ChatConfig({
    ChatChannelAccessVerificationCallback? channelAccessVerification,
    this.allowUnauthenticatedUsers = false,
    this.postMessagesLocallyOnly = false,
  }) {
    this.channelAccessVerification =
        channelAccessVerification ?? (Session session, int userId, String channel) async => true;
  }
}
