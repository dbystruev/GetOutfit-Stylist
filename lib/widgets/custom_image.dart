import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(String mediaUrl) {
  return CachedNetworkImage(
    errorWidget: (context, url, error) => Icon(Icons.error),
    fit: BoxFit.contain,
    imageUrl: mediaUrl,
    placeholder: (context, url) => Padding(
      child: CircularProgressIndicator(),
      padding: EdgeInsets.all(20),
    ),
  );
}
