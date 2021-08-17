import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecorderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RecorderScreen> {
  static const _platform =
      MethodChannel('com.flutterpoc.flutter_audio_recorder_poc/audio_recorder');

  bool _isRecording = false;
  String _errorMessage = "";

  void _toggleRecorder() async {
    try {
      if (_isRecording) {
        _isRecording = await _platform.invokeMethod("stop");
      } else {
        _isRecording = await _platform.invokeMethod("start");
      }
    } on PlatformException catch (e) {
      _isRecording = false;
      _errorMessage = e.message ?? "Unknown error";
    } on MissingPluginException catch (_) {
      _isRecording = false;
      _errorMessage =
          "This platform doesn't support the audio recording function.";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: _isRecording ? Text("STOP") : Text("Start"),
              onPressed: _toggleRecorder,
            ),
            Text(_errorMessage),
          ],
        ),
      ),
    );
  }
}
