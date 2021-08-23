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
private const val FLUTTER_CHANNEL =
    "com.flutterpoc.flutter_audio_recorder_poc/audio_recorder"
private const val PERMISSION_REQUEST_RECORD_AUDIO = 0

class MainActivity : FlutterActivity() {

    private lateinit var pendingChannelResult: Result
    private lateinit var methodChannel: MethodChannel
    private lateinit var filePath: String
    private lateinit var recorder: Recorder
    private lateinit var player: Player

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        configMethodChannels(flutterEngine)
    }

    private fun configMethodChannels(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor,
            FLUTTER_CHANNEL
        ).also {
            it.setMethodCallHandler { call, result ->
                when (call.method) {
                    "startRecorder" -> {
                        startRecordAudioFlow(result)
                    }
                    "stopRecorder" -> {
                        stopAudioRecorder(result)
                    }
                    "startPlayer" -> {
                        startPlayer(result)
                    }
                    "stopPlayer" -> {
                        stopPlayer(result)
                    }
                    else -> result.notImplemented()
                }
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

    private fun startAudioRecorder(result: Result) {
        filePath = "${externalCacheDir?.absolutePath}/${System.currentTimeMillis()}.pcm"
        Log.d(TAG, "file path: $filePath")
        recorder = Recorder(filePath, onRecordData = {
            runOnUiThread {
                Log.d(TAG, "Notify flutter we got analyzed sound data: $it")
                methodChannel.invokeMethod(METHOD_CALL_ON_RECORDER_UPDATE, it)
            }
        }, onRecorderStop = {
            runOnUiThread {
                methodChannel.invokeMethod(METHOD_CALL_ON_RECORDER_STOP, null)
            }
        })
        recorder.startRecording()
        result.success(true)
    }

    private fun stopAudioRecorder(result: Result) {
        recorder.stopRecording()
        result.success(false)
    }

    private fun startPlayer(result: Result) {
        Log.d(TAG, "Start player at path: $filePath")
        player = Player(filePath) {
            runOnUiThread {
                Log.d(TAG, "Notify flutter about EOF.")
                methodChannel.invokeMethod(METHOD_CALL_EOF, null)
            }
        }
        player.startPlaying()
        result.success(true)
    }

    private fun stopPlayer(result: Result) {
        player.stopPlaying()
        result.success(false)
    }
}
