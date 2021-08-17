package com.flutterpoc.flutter_audio_recorder_poc

import android.media.AudioFormat
import android.media.MediaRecorder

const val AUDIO_SOURCE = MediaRecorder.AudioSource.MIC
const val AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT
const val SAMPLE_RATE = 32000
const val AUDIO_CHANNEL = AudioFormat.CHANNEL_IN_MONO