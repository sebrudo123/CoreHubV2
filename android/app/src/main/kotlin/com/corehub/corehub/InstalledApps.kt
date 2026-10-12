package com.corehub.corehub

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Discovers installed Android games and cloud-gaming clients.
 */
class InstalledApps(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "com.corehub/apps"

        // Cloud/streaming clients that are not always tagged as games.
        private val KNOWN_GAME_PACKAGES = setOf(
            "com.microsoft.xcloud",
            "com.nvidia.geforcenow",
            "com.moonlight.stream",
            "com.xbox",
            "com.epicgames.launcher",
            "com.roblox.client",
            "com.mojang.minecraftpe",
            "com.supercell.clashofclans",
            "com.tencent.ig",
            "com.activision.callofduty.shooter"
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getGames" -> {
                val mainHandler = Handler(Looper.getMainLooper())
                Thread {
                    val games = collect()
                    mainHandler.post { result.success(games) }
                }.start()
            }
            "launch" -> launch(call, result)
            else -> result.notImplemented()
        }
    }

    private fun launch(call: MethodCall, result: MethodChannel.Result) {
        val pkg = call.argument<String>("package")
        if (pkg.isNullOrBlank()) {
            result.error("INVALID_ARGS", "package is required", null)
            return
        }
        val launchIntent = context.packageManager.getLaunchIntentForPackage(pkg)
        if (launchIntent == null) {
            result.error("NOT_FOUND", "No launch intent for $pkg", null)
            return
        }
        try {
            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(launchIntent)
            result.success(true)
        } catch (e: Exception) {
            result.error("LAUNCH_FAILED", e.message, null)
        }
    }

    private fun collect(): List<Map<String, Any?>> {
        val pm = context.packageManager
        val intent = Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER)
        val activities = pm.queryIntentActivities(intent, 0)

        val seen = HashSet<String>()
        val games = ArrayList<Map<String, Any?>>()

        for (info in activities) {
            val app = info.activityInfo.applicationInfo ?: continue
            val pkg = app.packageName
            if (!seen.add(pkg)) continue

            val isGame = app.category == ApplicationInfo.CATEGORY_GAME ||
                KNOWN_GAME_PACKAGES.contains(pkg)
            if (!isGame) continue

            games.add(
                mapOf(
                    "package" to pkg,
                    "name" to pm.getApplicationLabel(app).toString(),
                    "activity" to info.activityInfo.name
                )
            )
        }
        return games
    }
}
