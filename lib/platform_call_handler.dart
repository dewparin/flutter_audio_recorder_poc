import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _playerFinishedCall = 'playerReachEof';

class PlatformCallHandler extends ChangeNotifier {
  final MethodChannel platform;

  bool _isPlayerFinished = false;

  bool get isPlayerFinished => _isPlayerFinished;

  PlatformCallHandler(this.platform);

  void listeningToNative() {
    platform.setMethodCallHandler(platformCallHandler);
  }

  Future<dynamic> platformCallHandler(MethodCall methodCall) async {
    print("PlatformCallHandler # called");
    switch (methodCall.method) {
      case _playerFinishedCall:
        {
          print("PlatformCallHandler # playerReachEof");
          _isPlayerFinished = true;
          notifyListeners();
        }
    }
  }
}
