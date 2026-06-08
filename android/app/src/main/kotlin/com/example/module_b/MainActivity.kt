package com.example.module_b

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.media.MediaPlayer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var bgmPlayer: MediaPlayer? = null
    private var sensorManager: SensorManager? = null
    private var sensorEventListener: SensorEventListener? = null

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

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "gyro")
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                    sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
                    val gyroscope = sensorManager?.getDefaultSensor(Sensor.TYPE_GYROSCOPE)
                    sensorEventListener = object : SensorEventListener {
                        override fun onSensorChanged(event: SensorEvent) {
                            events.success(mapOf(
                                "x" to event.values[0],
                                "y" to event.values[1],
                                "z" to event.values[2],
                            ))
                        }
                        override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
                    }
                    sensorManager?.registerListener(
                        sensorEventListener,
                        gyroscope,
                        SensorManager.SENSOR_DELAY_GAME
                    )
                }

                override fun onCancel(arguments: Any?) {
                    sensorManager?.unregisterListener(sensorEventListener)
                }
            })
    }
}

