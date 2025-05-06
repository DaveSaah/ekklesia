import 'package:flutter/material.dart';

class TextMsgBubble extends StatelessWidget {
  final String messageText;
  final bool isOwnMessage;

  const TextMsgBubble({
    super.key,
    required this.messageText,
    this.isOwnMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color:
              isOwnMessage
                  ? Colors.deepOrangeAccent.shade100
                  : Colors.orangeAccent.withAlpha(60),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft:
                isOwnMessage
                    ? const Radius.circular(20)
                    : const Radius.circular(4),
            bottomRight:
                isOwnMessage
                    ? const Radius.circular(4)
                    : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          messageText,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
    );
  }
}
