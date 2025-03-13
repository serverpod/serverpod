import 'package:flutter/foundation.dart';

class SmsService {
  @visibleForTesting
  var sentTexts = <(String phone, String body)>[];

  void sendSms(String phone, String body) {
    sentTexts.add((phone, body));
  }
}
