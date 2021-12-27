/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessageAttachment extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatMessageAttachment';

  int? id;
  late String fileName;
  late String url;
  late String contentType;
  String? previewImage;
  int? previewWidth;
  int? previewHeight;

  ChatMessageAttachment({
    this.id,
    required this.fileName,
    required this.url,
    required this.contentType,
    this.previewImage,
    this.previewWidth,
    this.previewHeight,
  });

  ChatMessageAttachment.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    fileName = _data['fileName']!;
    url = _data['url']!;
    contentType = _data['contentType']!;
    previewImage = _data['previewImage'];
    previewWidth = _data['previewWidth'];
    previewHeight = _data['previewHeight'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'fileName': fileName,
      'url': url,
      'contentType': contentType,
      'previewImage': previewImage,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'fileName': fileName,
      'url': url,
      'contentType': contentType,
      'previewImage': previewImage,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
    });
  }
}
