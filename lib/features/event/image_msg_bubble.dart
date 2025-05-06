import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageMsgBubble extends StatelessWidget {
  final String imageUrl;
  final bool isMe;

  const ImageMsgBubble({super.key, required this.imageUrl, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isMe ? Colors.orangeAccent.withAlpha(51) : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder:
                (context, url) => Container(
                  padding: const EdgeInsets.all(16),
                  child: const CircularProgressIndicator(),
                ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
