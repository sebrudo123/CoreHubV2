package com.gamehub.droiddeck

import android.view.InputDevice
import android.view.MotionEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Host activity that wires every native subsystem to the Flutter engine.
 *
 * Native responsibilities:
 *  - ROM scanning (internal storage + MicroSD)
 *  - Emulator intent launching
 *  - System/hardware telemetry
 *  - Installed Android game discovery
 *  - Analog gamepad axis streaming (Flutter only exposes digital keys natively)
 */
class MainActivity : FlutterActivity() {

    private var gamepadChannel: GamepadChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, RomScanner.CHANNEL)
            .setMethodCallHandler(RomScanner(this))

        MethodChannel(messenger, EmulatorLauncher.CHANNEL)
            .setMethodCallHandler(EmulatorLauncher(this))

        MethodChannel(messenger, SystemMonitor.CHANNEL)
            .setMethodCallHandler(SystemMonitor(this))

        MethodChannel(messenger, InstalledApps.CHANNEL)
            .setMethodCallHandler(InstalledApps(this))

        gamepadChannel = GamepadChannel(messenger).also { it.register() }
    }

    override fun dispatchGenericMotionEvent(ev: MotionEvent): Boolean {
        val device = ev.device
        if (device != null &&
            (ev.source and InputDevice.SOURCE_JOYSTICK) == InputDevice.SOURCE_JOYSTICK &&
            ev.action == MotionEvent.ACTION_MOVE
        ) {
            gamepadChannel?.emitAxes(ev)
        }
        return super.dispatchGenericMotionEvent(ev)
    }

    override fun onDestroy() {
        gamepadChannel?.dispose()
        gamepadChannel = null
        super.onDestroy()
    }
}
