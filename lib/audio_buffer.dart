import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder_poc/platform_call_handler.dart';

const _onRecorderUpdateMethod = 'onRecorderUpdate';
const _onRecorderStopMethod = 'onRecorderStop';

class AudioBuffer extends ChangeNotifier {
  final PlatformCallHandler platformCallHandler;

  List<double> _recordData = [];
  List<double> get recordData => _recordData;

  AudioBuffer(this.platformCallHandler);

  void init() {
    platformCallHandler
      ..registerCallHandler(_onRecorderUpdateMethod, _onRecorderUpdate)
      ..registerCallHandler(_onRecorderStopMethod, (_) {
        _onRecorderStop();
      });
  }

  void _onRecorderUpdate(Object? data) async {
    final value = data != null ? data as double : 0.0;
    _recordData.add(value);
  }

  void _onRecorderStop() {
    print("AudioBuffer # _onRecorderStop");
    notifyListeners();
  }
}
