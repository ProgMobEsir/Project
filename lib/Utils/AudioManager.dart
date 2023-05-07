import 'package:just_audio/just_audio.dart';

class AudioManager {
  static AudioManager _singleton = AudioManager();

  final EffectChannel = AudioPlayer();
  final MusicChannel = AudioPlayer();

  AudioManager() {}

  static getInstance() {
    if (_singleton == null) {
      _singleton = AudioManager();
    }
    return _singleton;
  }

  Future<void> playEffect(String s) async {
    try {
      await EffectChannel.setAsset('assets/sounds/' + s);
      EffectChannel.play();
    } catch (e) {
      print(e);
    }
    EffectChannel.play();
  }

  Future<void> playMusic(String s) async {
    await MusicChannel.setAsset('assets/sounds/' + s)
        .then((value) => MusicChannel.play());
  }

  Future<void> setMusicVolume(double v) async {
    await MusicChannel.setVolume(v);
  }

  Future<void> setEffectVolume(double v) async {
    await EffectChannel.setVolume(v);
  }

  Future<double> getMusicVolume() async {
    return MusicChannel.volume;
  }

  Future<double> getEffectVolume() async {
    return EffectChannel.volume;
  }

  void stop() {
    EffectChannel.stop();
    MusicChannel.stop();
  }

}
