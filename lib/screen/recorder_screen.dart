import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder_poc/chart/waveform_chart.dart';
import 'package:flutter_audio_recorder_poc/player.dart';
import 'package:flutter_audio_recorder_poc/recorder.dart';
import 'package:provider/provider.dart';

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
                final status = recorder.statusMessage.isNotEmpty
                    ? recorder.statusMessage
                    : player.statusMessage;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.black12,
                      child: isRecording
                          ? CircularProgressIndicator()
                          : WaveformChart(data: _mockWaveData),
                    ),
                    OutlinedButton(
                      child:
                          isRecording ? Text("Stop Recording") : Text("Record"),
                      onPressed: isPlaying ? null : recorder.toggleRecorder,
                    ),
                    SizedBox(width: 8),
                    OutlinedButton(
                      child: isPlaying ? Text("Stop Playing") : Text("Play"),
                      // TODO: handle initial case where isRecording is false
                      onPressed: isRecording ? null : player.togglePlayer,
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
