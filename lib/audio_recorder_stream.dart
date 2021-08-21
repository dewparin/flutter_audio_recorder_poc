import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder_poc/platform_call_handler.dart';

const _onRecorderUpdateMethod = 'onRecorderUpdate';

class AudioRecorderStream {
  final MethodChannel platform;
  final PlatformCallHandler platformCallHandler;

  List<double> _recordData = [];

  final StreamController _streamController = StreamController<List<double>>();

  Stream<List<double>> get audioDataStream =>
      _streamController.stream as Stream<List<double>>;

  AudioRecorderStream(this.platform, this.platformCallHandler);

  void init() {
    platformCallHandler.registerCallHandler(
        _onRecorderUpdateMethod, _onRecorderUpdate);
  }

  void _onRecorderUpdate(Object? data) async {
    final value = data != null ? data as double : 0.0;
    _recordData.add(value);
    //simple delay
    if (_recordData.length % 50 == 0) {
      _streamController.add(_recordData);
    }
  }
}
