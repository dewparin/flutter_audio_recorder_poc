import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder_poc/platform_call_handler.dart';
import 'package:flutter_audio_recorder_poc/player.dart';
import 'package:flutter_audio_recorder_poc/recorder.dart';
import 'package:flutter_audio_recorder_poc/recorder_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final toNativeChannel = MethodChannel(
      'com.flutterpoc.flutter_audio_recorder_poc/flutter_to_native');
  final fromNativeChannel = MethodChannel(
      'com.flutterpoc.flutter_audio_recorder_poc/native_to_flutter');
  // final platformCallHandler = PlatformCallHandler(fromNativeChannel)
  //   ..listeningToNative();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Recorder(toNativeChannel)),
      ChangeNotifierProvider(
          create: (_) =>
              Player(toNativeChannel, fromNativeChannel)..listeningToNative()),
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
