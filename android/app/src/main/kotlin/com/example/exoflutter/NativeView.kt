package com.example.exoflutter

import android.content.Context
import android.util.Log
import android.view.View
import com.google.android.exoplayer2.C
import com.google.android.exoplayer2.MediaItem
import com.google.android.exoplayer2.SimpleExoPlayer
import com.google.android.exoplayer2.ui.PlayerView
import io.flutter.plugin.platform.PlatformView


internal class NativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private var simpleExoPlayer: SimpleExoPlayer? = null
    private lateinit var playerView: PlayerView

    override fun getView(): View {
        return playerView
    }

    override fun dispose() {}

    init {

        simpleExoPlayer = SimpleExoPlayer.Builder(context).build()
        playerView = PlayerView(context)
        playerView.player = simpleExoPlayer
        val mediaItem: MediaItem = MediaItem.Builder()
                .setUri("https://storage.googleapis.com/wvmedia/cenc/h264/tears/tears.mpd")
                .setDrmUuid(C.WIDEVINE_UUID)
                .setDrmLicenseUri("https://proxy.uat.widevine.com/proxy?video_id=GTS_SW_SECURE_CRYPTO&provider=widevine_test")
                .setDrmMultiSession(true)
                .build()

        playerView.player?.setMediaItem(mediaItem)
        playerView.player?.prepare()
        playerView.player?.play()
    }
}