import 'package:flutter/foundation.dart';

class MailService {
  @visibleForTesting
  var sentMails = <(String recipient, String body)>[];

  void sendMail(String recipient, String body) {
    sentMails.add((recipient, body));
  }
}
