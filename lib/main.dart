import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder_poc/audio_recorder_stream.dart';
import 'package:flutter_audio_recorder_poc/platform_call_handler.dart';
import 'package:flutter_audio_recorder_poc/player.dart';
import 'package:flutter_audio_recorder_poc/recorder.dart';
import 'package:flutter_audio_recorder_poc/recorder_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final platform =
      MethodChannel('com.flutterpoc.flutter_audio_recorder_poc/audio_recorder');
  final platformCallHandler = PlatformCallHandler(platform)..init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Recorder(platform)),
      ChangeNotifierProvider(
          create: (_) => Player(platform, platformCallHandler)..init()),
      Provider(
          create: (_) =>
              AudioRecorderStream(platform, platformCallHandler)..init()),
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
