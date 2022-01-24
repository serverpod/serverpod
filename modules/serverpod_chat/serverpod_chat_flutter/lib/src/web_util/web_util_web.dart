import 'dart:html';

void downloadURL(String url) {
  final anchorElement = AnchorElement(href: url);
  anchorElement.download = url;
  anchorElement.target = '_blank';
  anchorElement.click();
}
