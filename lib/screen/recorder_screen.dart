import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder_poc/audio_buffer.dart';
import 'package:flutter_audio_recorder_poc/chart/waveform_chart.dart';
import 'package:flutter_audio_recorder_poc/player.dart';
import 'package:flutter_audio_recorder_poc/recorder.dart';
import 'package:provider/provider.dart';

enum _FlowState { INITIAL, RECORDING, IDLE, PLAYING }

class RecorderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RecorderScreen> {
  bool _isInitialState = true;

  _FlowState _determineCurrentState(
      {required bool isRecording, required bool isPlaying}) {
    if (_isInitialState) {
      _isInitialState = false;
      return _FlowState.INITIAL;
    }
    if (isRecording) {
      return _FlowState.RECORDING;
    }
    if (isPlaying) {
      return _FlowState.PLAYING;
    }
    return _FlowState.IDLE;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer3<Recorder, AudioBuffer, Player>(
          builder: (_, recorder, audioBuffer, player, __) {
            final currentState = _determineCurrentState(
                isRecording: recorder.isRecording, isPlaying: player.isPlaying);
            final status = recorder.statusMessage.isNotEmpty
                ? recorder.statusMessage
                : player.statusMessage;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWaveformBar(currentState, audioBuffer),
                _buildRecordButton(currentState, recorder),
                SizedBox(width: 8),
                _buildPlayButton(currentState, player),
                Text(status),
              ],
            );
          },
        ),
      ),
    );
  }

  Container _buildWaveformBar(
      _FlowState currentState, AudioBuffer audioBuffer) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: EdgeInsets.all(8),
      color: Colors.black12,
      child: currentState == _FlowState.RECORDING
          ? Center(child: CircularProgressIndicator())
          : WaveformChart(
              data: audioBuffer.recordData,
            ),
    );
  }

  OutlinedButton _buildRecordButton(
      _FlowState currentState, Recorder recorder) {
    return OutlinedButton(
      child: currentState == _FlowState.RECORDING
          ? Text("Stop Recording")
          : Text("Record"),
      onPressed:
          currentState == _FlowState.PLAYING ? null : recorder.toggleRecorder,
    );
  }

  OutlinedButton _buildPlayButton(_FlowState currentState, Player player) {
    return OutlinedButton(
      child: currentState == _FlowState.PLAYING
          ? Text("Stop Playing")
          : Text("Play"),
      onPressed:
          currentState == _FlowState.IDLE || currentState == _FlowState.PLAYING
              ? player.togglePlayer
              : null,
    );
  }
}
