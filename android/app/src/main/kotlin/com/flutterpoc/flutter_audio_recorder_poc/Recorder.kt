package com.flutterpoc.flutter_audio_recorder_poc

import android.media.AudioFormat
import android.media.AudioRecord
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.nio.ByteBuffer
import java.util.concurrent.atomic.AtomicBoolean

const val AUDIO_IN_CHANNEL = AudioFormat.CHANNEL_IN_MONO
class Recorder(private val filePath: String, private val onRecordData: (Double) -> Unit) {

    private val bufferSize = AudioRecord.getMinBufferSize(
        SAMPLE_RATE,
        AUDIO_IN_CHANNEL,
        AUDIO_FORMAT
    ) * 2

    private lateinit var audioRecorder: AudioRecord
    private lateinit var recordingThread: Thread

    private val isRecording = AtomicBoolean(false)

    private fun buildRecorder() = AudioRecord.Builder()
        .setAudioSource(AUDIO_SOURCE)
        .setAudioFormat(
            AudioFormat.Builder()
                .setEncoding(AUDIO_FORMAT)
                .setSampleRate(SAMPLE_RATE)
                .setChannelMask(AUDIO_IN_CHANNEL)
                .build()
        )
        .setBufferSizeInBytes(bufferSize)
        .build()

    fun startRecording() {
        if (!isRecording.get()) {
            audioRecorder = buildRecorder().also {
                it.startRecording()
            }
            isRecording.set(true)
            recordingThread = Thread(recorderRunnable).also { it.start() }
        }
    }

    fun stopRecording() {
        if (isRecording.get()) {
            isRecording.set(false)
            audioRecorder.apply {
                stop()
                release()
            }
        }
    }

    private val recorderRunnable = Runnable {
        val file = File(filePath)
        val buffer: ByteBuffer = ByteBuffer.allocateDirect(bufferSize)

        val outStream = FileOutputStream(file)
        try {
            while (isRecording.get()) {
                val readCount = audioRecorder.read(buffer, bufferSize)
                if (readCount < 0) {
                    throw RuntimeException("Failed to read")
                }
                Log.d("Recorder", "Writing $readCount bytes to $filePath")
                val data = buffer.array()
                // TODO: analyze sound wave data before notify callback
                onRecordData(getMockNumber())
                outStream.write(data, 0, bufferSize)
                buffer.clear()
            }
        } catch (e: IOException) {
            Log.e("Recorder", "Error: ${e.localizedMessage}")
        } finally {
            outStream.close()
        }
    }

    private fun getMockNumber(): Double = (0..100).random().toDouble()
}