/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessageAttachmentUploadDescription extends SerializableEntity {
  @override
  String get className =>
      'serverpod_chat_server.ChatMessageAttachmentUploadDescription';

  int? id;
  late String filePath;
  late String uploadDescription;

  ChatMessageAttachmentUploadDescription({
    this.id,
    required this.filePath,
    required this.uploadDescription,
  });

  ChatMessageAttachmentUploadDescription.fromSerialization(
      Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    filePath = _data['filePath']!;
    uploadDescription = _data['uploadDescription']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'filePath': filePath,
      'uploadDescription': uploadDescription,
    });
  }
}
