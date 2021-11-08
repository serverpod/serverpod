/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

class _EndpointChat extends EndpointRef {
  @override
  String get name => 'serverpod_chat.chat';

  _EndpointChat(EndpointCaller caller) : super(caller);

  Future<ChatMessageAttachmentUploadDescription?> createAttachmentUploadDescription(String fileName,) async {
    return await caller.callServerEndpoint('serverpod_chat.chat', 'createAttachmentUploadDescription', 'ChatMessageAttachmentUploadDescription', {
      'fileName':fileName,
    });
  }

  Future<ChatMessageAttachment?> verifyAttachmentUpload(String fileName,String filePath,) async {
    return await caller.callServerEndpoint('serverpod_chat.chat', 'verifyAttachmentUpload', 'ChatMessageAttachment', {
      'fileName':fileName,
      'filePath':filePath,
    });
  }
}

class Caller extends ModuleEndpointCaller {
  late final _EndpointChat chat;

  Caller(ServerpodClientShared client) : super(client) {
    chat = _EndpointChat(this);
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
    'serverpod_chat.chat' : chat,
  };
}
