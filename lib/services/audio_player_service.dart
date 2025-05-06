import 'package:flutter_sound/flutter_sound.dart';

class AudioPlayerService {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  Future<void> init() async {
    await _player.openPlayer();
  }

  Future<void> play(String url) async {
    await _player.startPlayer(
      fromURI: url,
      codec: Codec.aacMP4,
      whenFinished: () {
        print('Playback finished');
      },
    );
  }

  Future<void> stop() async {
    await _player.stopPlayer();
  }

  void dispose() {
    _player.closePlayer();
  }
}
