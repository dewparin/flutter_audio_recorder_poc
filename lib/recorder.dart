import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder_poc/platform_call_handler.dart';

const _startRecordMethod = 'startRecorder';
const _stopRecordMethod = 'stopRecorder';
const _onRecorderUpdateMethod = 'onRecorderUpdate';

class Recorder extends ChangeNotifier {
  final MethodChannel platform;
  final PlatformCallHandler platformCallHandler;

  bool _isRecording = false;

  bool get isRecording => _isRecording;

  String _status = "";

  String get statusMessage => _status;

  Recorder(this.platform, this.platformCallHandler);

  void init() {
    platformCallHandler.registerCallHandler(
        _onRecorderUpdateMethod, _onRecorderUpdate);
  }

  void _onRecorderUpdate(Object? data) {
    final value = data != null ? data as double : 0.0;
    print("_onRecorderUpdate : value = $value");
    //TODO: notify listener
  }

  void toggleRecorder() async {
    _status = "";
    try {
      if (!_isRecording) {
        _isRecording = await platform.invokeMethod(_startRecordMethod);
      } else {
        _isRecording = await platform.invokeMethod(_stopRecordMethod);
      }
    } on PlatformException catch (e) {
      _isRecording = false;
      _status = e.message ?? "Unknown error";
    } on MissingPluginException catch (_) {
      _isRecording = false;
      _status = "This platform doesn't support the audio recording function.";
    } finally {
      notifyListeners();
    }
  }
}
