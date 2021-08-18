import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder_poc/player.dart';
import 'package:flutter_audio_recorder_poc/recorder.dart';
import 'package:flutter_audio_recorder_poc/recorder_screen.dart';
import 'package:provider/provider.dart';

void main() {
  final platform =
      MethodChannel('com.flutterpoc.flutter_audio_recorder_poc/audio_recorder');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Recorder(platform)),
      ChangeNotifierProvider(create: (_) => Player(platform)),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecorderScreen(),
    );
  }
}
