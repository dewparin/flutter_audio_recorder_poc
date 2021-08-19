import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _startPlayingMethod = 'startPlayer';
const _stopPlayingMethod = 'stopPlayer';
const _playerFinishedCall = 'playerReachEof';

class Player extends ChangeNotifier {
  final MethodChannel toNativeChannel;
  final MethodChannel fromNativeChannel;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  String _status = "";

  String get statusMessage => _status;

  Player(this.toNativeChannel, this.fromNativeChannel);

  void listeningToNative() {
    fromNativeChannel.setMethodCallHandler(platformCallHandler);
  }

  Future<dynamic> platformCallHandler(MethodCall methodCall) async {
    print("PlatformCallHandler # called");
    switch (methodCall.method) {
      case _playerFinishedCall:
        {
          print("PlatformCallHandler # playerReachEof");
          _isPlaying = false;
          notifyListeners();
        }
    }
  }

  void togglePlayer() async {
    _status = "";
    try {
      if (!_isPlaying) {
        _isPlaying = await toNativeChannel.invokeMethod(_startPlayingMethod);
      } else {
        _isPlaying = await toNativeChannel.invokeMethod(_stopPlayingMethod);
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
