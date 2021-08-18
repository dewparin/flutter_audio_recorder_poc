import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _startPlayingMethod = 'startPlayer';
const _stopPlayingMethod = 'stopPlayer';

class Player extends ChangeNotifier {
  final MethodChannel platform;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  String _status = "";

  String get statusMessage => _status;

  Player(this.platform);

  void togglePlayer() async {
    _status = "";
    try {
      if (!_isPlaying) {
        _isPlaying = await platform.invokeMethod(_startPlayingMethod);
      } else {
        _isPlaying = await platform.invokeMethod(_stopPlayingMethod);
      }
    } on PlatformException catch (e) {
      _isPlaying = false;
      _status = e.message ?? "Unknown error";
    } on MissingPluginException catch (_) {
      _isPlaying = false;
      _status = "This platform doesn't support the audio playing function.";
    } finally {
      notifyListeners();
    }
  }
}
