package com.gamehub.droiddeck

import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Real-time hardware telemetry: battery, CPU load, RAM usage, SoC temperature
 * and system clock.
 */
class SystemMonitor(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "com.gamehub/system"
        private const val CPU_SAMPLE_MS = 200L
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getStats" -> {
                val mainHandler = Handler(Looper.getMainLooper())
                Thread {
                    val stats = collect()
                    mainHandler.post { result.success(stats) }
                }.start()
            }
            else -> result.notImplemented()
        }
    }

    private fun collect(): Map<String, Any?> {
        val batteryIntent = context.registerReceiver(
            null,
            IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        )
        val level = batteryIntent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = batteryIntent?.getIntExtra(BatteryManager.EXTRA_SCALE, 100) ?: 100
        val levelPct = if (level >= 0 && scale > 0) level * 100 / scale else -1
        val status = batteryIntent?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        val charging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
            status == BatteryManager.BATTERY_STATUS_FULL
        val tempTenths = batteryIntent?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0) ?: 0

        val activityManager =
            context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memInfo)
        val mb = 1024.0 * 1024.0

        return mapOf(
            "batteryLevel" to levelPct,
            "charging" to charging,
            "cpuLoad" to readCpuLoad(),
            "ramTotalMb" to (memInfo.totalMem / mb),
            "ramUsedMb" to ((memInfo.totalMem - memInfo.availMem) / mb),
            "temperature" to (tempTenths / 10.0),
            "clock" to System.currentTimeMillis(),
            "uptime" to SystemClock.elapsedRealtime()
        )
    }

    private fun readCpuLoad(): Double {
        val first = readCpuTicks() ?: return 0.0
        try {
            Thread.sleep(CPU_SAMPLE_MS)
        } catch (e: InterruptedException) {
            Thread.currentThread().interrupt()
        }
        val second = readCpuTicks() ?: return 0.0

        val totalDelta = second.first - first.first
        val idleDelta = second.second - first.second
        if (totalDelta <= 0L) return 0.0
        val load = (totalDelta - idleDelta).toDouble() / totalDelta.toDouble() * 100.0
        return load.coerceIn(0.0, 100.0)
    }

    /** Returns (totalTicks, idleTicks) from /proc/stat. */
    private fun readCpuTicks(): Pair<Long, Long>? {
        return try {
            val line = File("/proc/stat").useLines { lines ->
                lines.firstOrNull { it.startsWith("cpu ") }
            } ?: return null

            val values = line.trim().split(Regex("\\s+")).drop(1).mapNotNull { it.toLongOrNull() }
            if (values.size < 4) return null
            val idle = values[3] + (values.getOrNull(4) ?: 0L)
            val total = values.sum()
            Pair(total, idle)
        } catch (e: Exception) {
            null
        }
    }
}
