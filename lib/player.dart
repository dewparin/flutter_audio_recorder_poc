import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder_poc/platform_call_handler.dart';

const _startPlayingMethod = 'startPlayer';
const _stopPlayingMethod = 'stopPlayer';
const _playerFinishedCall = 'playerReachEof';

class Player extends ChangeNotifier {
  final MethodChannel platform;
  final PlatformCallHandler platformCallHandler;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  String _status = "";

  String get statusMessage => _status;

  Player(this.platform, this.platformCallHandler);

  void init() {
    platformCallHandler.registerCallHandler(_playerFinishedCall, (_) {
      _onPlayerReachEof();
    });
  }

  void _onPlayerReachEof() {
    print("Player # _onPlayerReachEof");
    _isPlaying = false;
    notifyListeners();
  }

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
