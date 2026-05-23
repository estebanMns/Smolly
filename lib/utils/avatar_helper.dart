import 'package:flutter/material.dart';
import '../config/app_assets.dart';

ImageProvider getAvatarImageProvider(String? url) {
  if (url == null || url.isEmpty) {
    return const NetworkImage(AppAssets.fallbackAvatarUrl);
  }
  if (url.startsWith('http')) {
    return NetworkImage(url);
  }
  return AssetImage(url);
}
