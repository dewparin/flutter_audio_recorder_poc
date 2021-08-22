import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder_poc/chart/waveform_chart.dart';
import 'package:flutter_audio_recorder_poc/player.dart';
import 'package:flutter_audio_recorder_poc/recorder.dart';
import 'package:provider/provider.dart';

enum _State { INITIAL, IDLE, RECORDING, PLAYING }

const _mockWaveData = [
  34.0,
  49.0,
  58.0,
  32.0,
  28.0,
  40.0,
  50.0,
];

class RecorderScreen extends StatelessWidget {
  bool _isInitialState = true;

  _State _determineCurrentState(
      {required bool isRecording, required bool isPlaying}) {
    if (_isInitialState) {
      _isInitialState = false;
      return _State.INITIAL;
    }

    if (isRecording) {
      return _State.RECORDING;
    }
    if (isPlaying) {
      return _State.PLAYING;
    }
    return _State.IDLE;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer2<Recorder, Player>(
              builder: (context, recorder, player, child) {
                final isRecording = recorder.isRecording;
                final isPlaying = player.isPlaying;
                final currentState = _determineCurrentState(
                    isRecording: isRecording, isPlaying: isPlaying);
                final status = recorder.statusMessage.isNotEmpty
                    ? recorder.statusMessage
                    : player.statusMessage;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.black12,
                      child: currentState == _State.RECORDING
                          ? CircularProgressIndicator()
                          : WaveformChart(
                              data: _mockWaveData,
                            ),
                    ),
                    OutlinedButton(
                      child: currentState == _State.RECORDING
                          ? Text("Stop Recording")
                          : Text("Record"),
                      onPressed: isPlaying ? null : recorder.toggleRecorder,
                    ),
                    SizedBox(width: 8),
                    OutlinedButton(
                      child: currentState == _State.PLAYING
                          ? Text("Stop Playing")
                          : Text("Play"),
                      onPressed: currentState == _State.IDLE
                          ? player.togglePlayer
                          : null,
                    ),
                    Text(status),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
