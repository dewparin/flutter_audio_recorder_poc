package com.flutterpoc.flutter_audio_recorder_poc

import android.Manifest
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

private const val TAG = "MainActivity"
private const val CHANNEL = "com.flutterpoc.flutter_audio_recorder_poc/audio_recorder"
private const val PERMISSION_REQUEST_RECORD_AUDIO = 0

class MainActivity : FlutterActivity() {

    private lateinit var pendingChannelResult: Result

    private lateinit var filePath: String
    private lateinit var recorder: Recorder
    private lateinit var player: Player

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    startRecordAudioFlow(result)
                }
                "stop" -> {
                    stopAudioRecorder()
                    result.success(false)
                }
                "startPlayer" -> {
                    startPlayer()
                    result.success(true)
                }
                "stopPlayer" -> {
                    stopPlayer()
                    result.success(false)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        if (requestCode == PERMISSION_REQUEST_RECORD_AUDIO) {
            if (grantResults.size == 1 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                startAudioRecorder(pendingChannelResult)
            } else {
                pendingChannelResult.error("PERMISSION_DENIED", "Permission Denied", null)
            }
        }
    }

    private fun startRecordAudioFlow(result: Result) {
        if (!isRecordAudioPermissionGranted()) {
            pendingChannelResult = result
            requestRecordAudioPermission()
        } else {
            startAudioRecorder(result)
        }
    }

    private fun isRecordAudioPermissionGranted() = ActivityCompat.checkSelfPermission(
        this,
        Manifest.permission.RECORD_AUDIO
    ) == PackageManager.PERMISSION_GRANTED

    private fun requestRecordAudioPermission() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.RECORD_AUDIO),
            PERMISSION_REQUEST_RECORD_AUDIO
        )
    }

    private fun startAudioRecorder(result: Result) {
        filePath = "${externalCacheDir?.absolutePath}/${System.currentTimeMillis()}.pcm"
        Log.d(TAG, "file path: $filePath")
        recorder = Recorder(filePath).also {
            it.startRecording()
        }
        result.success(true)
    }

    private fun stopAudioRecorder() {
        recorder.stopRecording()
    }

    private fun startPlayer() {
        Log.d(TAG, "Start player at path: $filePath")
        player = Player(filePath).also {
            it.startPlaying()
        }
    }

    private fun stopPlayer() {
        player.stopPlaying()
    }
}
