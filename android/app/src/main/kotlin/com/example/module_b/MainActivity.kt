package com.example.module_b

import android.media.MediaPlayer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var bgmPlayer: MediaPlayer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "audio"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "playBGM" -> {
                    bgmPlayer?.release()
                    val afd = assets.openFd("bgm.mp3")
                    bgmPlayer = MediaPlayer().apply {
                        setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                        isLooping = true
                        prepare()
                        start()
                    }

                    result.success(null)
                }

                "stopBGM" -> {
                    bgmPlayer?.pause()
                    result.success(null)
                }

                "restartBGM" -> {
                    bgmPlayer?.start()
                    result.success(null)
                }

                "endBGM" -> {
                    bgmPlayer?.stop()
                    bgmPlayer?.release()
                    bgmPlayer = null
                    result.success(null)
                }

                "setSound" -> {
                    val sound = call.argument<Double>("sound")?.toFloat() ?: 1f
                    bgmPlayer?.setVolume(sound, sound)
                    result.success(null)
                }

                "soundEffect" -> {
                    val effectName = call.argument<String>("effectName")!!
                    val afd = assets.openFd(effectName)
                    MediaPlayer().apply {
                        setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                        prepare()
                        start()
                        setOnCompletionListener { release() }
                    }
                    result.success(null)
                }
            }
        }
    }
}
