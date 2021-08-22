import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _startRecordMethod = 'startRecorder';
const _stopRecordMethod = 'stopRecorder';

class Recorder extends ChangeNotifier {
  final MethodChannel platform;

  bool _isRecording = false;

  bool get isRecording => _isRecording;

  String _status = "";

  String get statusMessage => _status;

  Recorder(this.platform);

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
