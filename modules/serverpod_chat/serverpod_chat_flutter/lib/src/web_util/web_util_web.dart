import 'dart:html';

void downloadURL(String url) {
  AnchorElement anchorElement = AnchorElement(href: url);
  anchorElement.download = url;
  anchorElement.target = '_blank';
  anchorElement.click();
}
