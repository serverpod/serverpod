

import 'dart:io';

/// Represents a content type.
final contentType = {
  '.js': ContentType('text', 'javascript'),
  '.css': ContentType('text', 'css'),
  '.png': ContentType('image', 'png'),
  '.jpg': ContentType('image', 'jpeg'),
  '.svg': ContentType('image', 'svg+xml'),
  '.ttf': ContentType('application', 'x-font-ttf'),
  '.woff': ContentType('application', 'x-font-woff'),
  '.pdf': ContentType('application', 'pdf'),
  '.epub': ContentType('application', 'epub+zip'),
  '.zip': ContentType('application', 'zip'),
  '.rar': ContentType('application', 'x-rar-compressed'),
  '.doc': ContentType('application', 'msword'),
  '.docx': ContentType('application', 'vnd.openxmlformats-officedocument.wordprocessingml.document'),
  '.xls': ContentType('application', 'vnd.ms-excel'),
  '.xlsx': ContentType('application', 'vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
  '.ppt': ContentType('application', 'vnd.ms-powerpoint'),
  '.pptx': ContentType('application', 'vnd.openxmlformats-officedocument.presentationml.presentation'),
  '.mp3': ContentType('audio', 'mpeg'),
  '.mp4': ContentType('video', 'mp4'),
  '.avi': ContentType('video', 'x-msvideo'),
  '.wmv': ContentType('video', 'x-ms-wmv'),
  '.flv': ContentType('video', 'x-flv'),
  '.mov': ContentType('video', 'quicktime'),
  '.webm': ContentType('video', 'webm'),
  '.ogg': ContentType('video', 'ogg'),
  '.mpg': ContentType('video', 'mpeg'),
  '.mpeg': ContentType('video', 'mpeg'),
  '.m4v': ContentType('video', 'mp4'),
  '.mkv': ContentType('video', 'x-matroska'),
  '.3gp': ContentType('video', '3gpp'),
  '.3g2': ContentType('video', '3gpp2'),

};