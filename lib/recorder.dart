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

  List<double> _recordData = [];

  List<double> get recordData => _recordData;

  Recorder(this.platform, this.platformCallHandler);

  void init() {
    platformCallHandler.registerCallHandler(
        _onRecorderUpdateMethod, _onRecorderUpdate);
  }ª

  void _onRecorderUpdate(Object? data) {
    final value = data != null ? data as double : 0.0;
    print("_onRecorderUpdate : value = $value");
    // TODO: try notify view via StreamController
    _recordData.add(value);
    notifyListeners();
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
