import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(String mediaUrl) {
  return kIsWeb
      ? Image.network(
          mediaUrl,
          repeat: ImageRepeat.noRepeat,
          scale: 1,
        )
      : CachedNetworkImage(
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.contain,
          imageUrl: mediaUrl,
          placeholder: (context, url) => Padding(
            child: CircularProgressIndicator(),
            padding: EdgeInsets.all(20),
          ),
        );
}
