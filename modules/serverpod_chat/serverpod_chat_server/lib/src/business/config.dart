import 'package:serverpod/server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

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

  /// Post messages globally in the server cluster (i.e. use Redis).
  final bool postMessagesGlobally;

  /// Callback for when a message is about to be sent to a user. Return false
  /// to prevent the message from being sent.
  final Future<bool> Function(
    Session session,
    UserInfo userInfo,
    String channel,
  )? onWillSendMessage;

  /// Callback for when a message has been sent to a user.
  final Future<void> Function(
    Session session,
    UserInfo userInfo,
    String channel,
  )? onDidSendMessage;

  /// Create a new [ChatConfig].
  ChatConfig({
    ChatChannelAccessVerificationCallback? channelAccessVerification,
    this.allowUnauthenticatedUsers = false,
    this.postMessagesGlobally = false,
    this.onWillSendMessage,
    this.onDidSendMessage,
  }) {
    this.channelAccessVerification =
        channelAccessVerification ?? (session, userId, channel) async => true;
  }
}
