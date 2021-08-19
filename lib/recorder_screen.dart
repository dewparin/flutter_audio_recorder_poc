import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder_poc/player.dart';
import 'package:flutter_audio_recorder_poc/recorder.dart';
import 'package:provider/provider.dart';

class RecorderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer2<Recorder, Player>(
          builder: (context, recorder, player, child) {
            final isRecording = recorder.isRecording;
            final isPlaying = player.isPlaying;
            final status = recorder.statusMessage.isNotEmpty
                ? recorder.statusMessage
                : player.statusMessage;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  child: isRecording ? Text("Stop Recording") : Text("Record"),
                  onPressed: isPlaying ? null : recorder.toggleRecorder,
                ),
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
      ),
    );
  }
}
