package com.example.exoflutter

import android.os.Bundle
import android.util.Log
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.ui.PlayerView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity() {
    companion object {
        private const val CHANNEL_NAME = "com.example/exoflutter"
        private const val METHOD_GET_ANDROID_VERSION = "getPlatformVersion"
        private const val METHOD_CREATE_PLAYER = "createPlayer"
    }

    private lateinit var channel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)

        channel.setMethodCallHandler { methodCall: MethodCall, result: MethodChannel.Result ->
            if (methodCall.method == METHOD_GET_ANDROID_VERSION) {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            } else if (methodCall.method == METHOD_CREATE_PLAYER) {
                flutterEngine
                        .platformViewsController
                        .registry
                        .registerViewFactory("com.exoplayer.playerview", NativeViewFactory())
                result.success(true)
            }
            else
                result.notImplemented()
        }
    }

}
