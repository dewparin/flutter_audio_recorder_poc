package com.flutterpoc.flutter_audio_recorder_poc

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.util.Log
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.util.concurrent.atomic.AtomicBoolean

const val AUDIO_OUT_CHANNEL = AudioFormat.CHANNEL_OUT_MONO

class Player(private val filePath: String) {

    private lateinit var track: AudioTrack
    private lateinit var playerThread: Thread

    private val isPlaying = AtomicBoolean(false)
    private val bufferSize = AudioTrack.getMinBufferSize(
        SAMPLE_RATE,
        AUDIO_OUT_CHANNEL,
        AUDIO_FORMAT
    )

    private fun buildTrack(): AudioTrack {
        val attrs = AudioAttributes.Builder()
            .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
            .setUsage(AudioAttributes.USAGE_MEDIA)
            .build()
        val format = AudioFormat.Builder()
            .setEncoding(AUDIO_FORMAT)
            .setSampleRate(SAMPLE_RATE)
            .setChannelMask(AUDIO_OUT_CHANNEL)
            .build()
        return AudioTrack(
            attrs,
            format,
            bufferSize,
            AudioTrack.MODE_STREAM,
            AudioManager.AUDIO_SESSION_ID_GENERATE
        )
    }

    fun startPlaying() {
        if (!isPlaying.get()) {
            track = buildTrack().also { it.play() }
            isPlaying.set(true)
            playerThread = Thread(playerRunnable).also { it.start() }
        }
    }

    fun stopPlaying() {
        if (isPlaying.get()) {
            isPlaying.set(false)
            track.apply {
                stop()
                release()
            }
        }
    }

    private val playerRunnable = Runnable {
        val file = File(filePath)
        val buffer = ByteArray(bufferSize / 2)
        val inStream = FileInputStream(file)
        try {
            var readCount = 0
            while (readCount != -1 && isPlaying.get()) {
                readCount = inStream.read(buffer)
                Log.d("Player", "Writing $readCount bytes to AudioTrack")
                track.write(buffer, 0, readCount)
            }
            Log.d("Player", "EOF")
        } catch (e: IOException) {
            Log.e("Player", "Error: ${e.localizedMessage}")
        } finally {
            inStream.close()
        }
    }
}