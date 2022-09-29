import 'package:serverpod/server.dart';

/// Callback for verifying if a user is allowed to join a channel. Return
/// true if the user is allowed to join the channel.
typedef ChatChannelAccessVerificationCallback = Future<bool> Function(
    Session session, int userId, String channel);

/// Configuration for the server part of the chat module.
class ChatConfig {
  static ChatConfig _config = ChatConfig();

  /// Updates the configuration used by the Auth module.
  static void set(ChatConfig config) {
    _config = config;
  }

  /// Gets the current Auth module configuration.
  static ChatConfig get current => _config;

  /// Callback for verifying if a user is allowed to join a channel. Return
  /// true if the user is allowed to join the channel.
  late final ChatChannelAccessVerificationCallback channelAccessVerification;

  /// Allow users to chat even though they aren't signed in.
  final bool allowUnauthenticatedUsers;

  /// Post messages locally in the server only (i.e. do not use Redis).
  final bool postMessagesLocallyOnly;

  /// Create a new [ChatConfig].
  ChatConfig({
    ChatChannelAccessVerificationCallback? channelAccessVerification,
    this.allowUnauthenticatedUsers = false,
    this.postMessagesLocallyOnly = false,
  }) {
    this.channelAccessVerification =
        channelAccessVerification ?? (session, userId, channel) async => true;
  }
}
