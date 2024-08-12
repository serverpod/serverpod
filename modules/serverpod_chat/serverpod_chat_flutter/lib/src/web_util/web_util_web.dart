
import 'package:web/web.dart';

/// Downloads the specified [url] to the download folder of the computer.
void downloadURL(String url) {
  var anchorElement = HTMLAnchorElement();
  anchorElement.href = url;
  anchorElement.download = url;
  anchorElement.target = '_blank';
  anchorElement.click();
}
