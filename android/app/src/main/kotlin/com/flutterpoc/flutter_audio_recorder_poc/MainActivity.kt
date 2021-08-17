package com.flutterpoc.flutter_audio_recorder_poc

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.flutterpoc.flutter_audio_recorder_poc/audio_recorder"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    result.success(true)
                }
                "stop" -> {
                    result.success(false)
                }
                else -> result.notImplemented()
            }
        }
    }
}
