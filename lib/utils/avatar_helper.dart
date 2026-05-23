import 'package:flutter/material.dart';

ImageProvider getAvatarImageProvider(String? url) {
  if (url == null || url.isEmpty) {
    return const AssetImage('assets/images/kovu.jpeg');
  }
  if (url.startsWith('http')) {
    return NetworkImage(url);
  }
  return AssetImage(url);
}
