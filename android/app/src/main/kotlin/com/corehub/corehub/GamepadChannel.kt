package com.corehub.corehub

import android.os.Handler
import android.os.Looper
import android.view.MotionEvent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

/**
 * Streams analog gamepad axis data to Dart.
 *
 * Flutter exposes digital keys (D-Pad / face buttons) natively through its focus
 * system, but analog sticks and analog triggers are not surfaced, so they are
 * forwarded here as a throttled event stream.
 */
class GamepadChannel(private val messenger: BinaryMessenger) {

    companion object {
        const val CHANNEL = "com.corehub/gamepad"
        private const val EMIT_INTERVAL_MS = 16L // ~60 Hz
    }

    private var sink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private var lastEmit = 0L

    fun register() {
        EventChannel(messenger, CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    sink = events
                }

                override fun onCancel(arguments: Any?) {
                    sink = null
                }
            }
        )
    }

    fun emitAxes(ev: MotionEvent) {
        val now = System.currentTimeMillis()
        if (now - lastEmit < EMIT_INTERVAL_MS) return
        lastEmit = now

        val payload = mapOf(
            "x" to ev.getAxisValue(MotionEvent.AXIS_X).toDouble(),
            "y" to ev.getAxisValue(MotionEvent.AXIS_Y).toDouble(),
            "z" to ev.getAxisValue(MotionEvent.AXIS_Z).toDouble(),
            "rz" to ev.getAxisValue(MotionEvent.AXIS_RZ).toDouble(),
            "hatX" to ev.getAxisValue(MotionEvent.AXIS_HAT_X).toDouble(),
            "hatY" to ev.getAxisValue(MotionEvent.AXIS_HAT_Y).toDouble(),
            "lt" to ev.getAxisValue(MotionEvent.AXIS_LTRIGGER).toDouble(),
            "rt" to ev.getAxisValue(MotionEvent.AXIS_RTRIGGER).toDouble()
        )

        val target = sink ?: return
        mainHandler.post { target.success(payload) }
    }

    fun dispose() {
        sink = null
    }
}
