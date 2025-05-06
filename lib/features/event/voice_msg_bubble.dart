import 'package:flutter/material.dart';
import 'package:ekklesia/services/audio_player_service.dart';

class VoiceMsgBubble extends StatelessWidget {
  final String audioUrl;
  final AudioPlayerService audioPlayerService;
  final bool isOwnMessage;

  const VoiceMsgBubble({
    super.key,
    required this.audioUrl,
    required this.audioPlayerService,
    this.isOwnMessage = true, // Add the isOwnMessage parameter
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          isOwnMessage
              ? Alignment.centerRight
              : Alignment.centerLeft, // Align based on message origin
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orangeAccent.withAlpha(51),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.audiotrack, color: Colors.deepOrange),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () async {
                await audioPlayerService.play(audioUrl);
                print(audioUrl);
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
