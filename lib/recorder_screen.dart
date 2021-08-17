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
  bool _isPlaying = false;
  String _errorMessage = "";

  void _toggleRecorder() async {
    _errorMessage = "";
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

  void _togglePlayer() async {
    _errorMessage = "";
    try {
      if (_isPlaying) {
        _isPlaying = await _platform.invokeMethod("stopPlayer");
      } else {
        _isPlaying = await _platform.invokeMethod("startPlayer");
      }
    } on PlatformException catch (e) {
      _isPlaying = false;
      _errorMessage = e.message ?? "Unknown error";
    } on MissingPluginException catch (_) {
      _isPlaying = false;
      _errorMessage =
      "This platform doesn't support the audio playing function.";
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
              child: _isRecording ? Text("Stop Recording") : Text("Record"),
              onPressed: _toggleRecorder,
            ),
            OutlinedButton(
              child: _isPlaying ? Text("Stop Playing") : Text("Play"),
              onPressed: _togglePlayer,
            ),
            Text(_errorMessage),
          ],
        ),
      ),
    );
  }
}
