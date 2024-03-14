/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_chat_client/src/protocol/chat_message_attachment_upload_description.dart'
    as _i3;
import 'package:serverpod_chat_client/src/protocol/chat_message_attachment.dart'
    as _i4;

/// Connect to the chat endpoint to send and receive chat messages.
/// {@category Endpoint}
class EndpointChat extends _i1.EndpointRef {
  EndpointChat(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverpod_chat.chat';

  /// Creates a description for uploading an attachment.
  _i2.Future<_i3.ChatMessageAttachmentUploadDescription?>
      createAttachmentUploadDescription(String fileName) => caller
              .callServerEndpoint<_i3.ChatMessageAttachmentUploadDescription?>(
            'serverpod_chat.chat',
            'createAttachmentUploadDescription',
            {'fileName': fileName},
          );

  /// Verifies that an attachment has been uploaded.
  _i2.Future<_i4.ChatMessageAttachment?> verifyAttachmentUpload(
    String fileName,
    String filePath,
  ) =>
      caller.callServerEndpoint<_i4.ChatMessageAttachment?>(
        'serverpod_chat.chat',
        'verifyAttachmentUpload',
        {
          'fileName': fileName,
          'filePath': filePath,
        },
      );
}

class Caller extends _i1.ModuleEndpointCaller {
  Caller(_i1.ServerpodClientShared client) : super(client) {
    chat = EndpointChat(this);
  }

  late final EndpointChat chat;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup =>
      {'serverpod_chat.chat': chat};
}
