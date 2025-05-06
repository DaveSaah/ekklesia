import 'package:flutter/material.dart';
import 'package:ekklesia/services/audio_player_service.dart';

class VoiceMsgBubble extends StatelessWidget {
  final String audioUrl;
  final AudioPlayerService audioPlayerService;

  const VoiceMsgBubble({
    super.key,
    required this.audioUrl,
    required this.audioPlayerService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
