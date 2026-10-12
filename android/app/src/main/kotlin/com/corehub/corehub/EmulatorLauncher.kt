package com.corehub.corehub

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.StrictMode
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Launch emulator front-ends through Android Intents, forwarding the ROM path
 * and optional command-line arguments.
 */
class EmulatorLauncher(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "com.corehub/emulator"

        private val RETROARCH = listOf(
            "com.retroarch.aarch64",
            "com.retroarch.ra32",
            "com.retroarch"
        )

        private val PLATFORM_EMULATORS = mapOf(
            "ps1" to listOf("com.github.stenzek.duckstation") + RETROARCH,
            "ps2" to listOf("xyz.aethersx2.android", "xyz.aethersx2.android.dev") + RETROARCH,
            "psp" to listOf("org.ppsspp.ppsspp", "org.ppsspp.ppssppgold"),
            "gamecube" to listOf("org.dolphinemu.dolphinemu"),
            "wii" to listOf("org.dolphinemu.dolphinemu"),
            "nds" to listOf("org.citra.emu", "org.citra.citra_emu") + RETROARCH,
            "n3ds" to listOf("org.citra.emu", "org.citra.citra_emu"),
            "switch" to listOf("org.yuzu.yuzu_emu", "org.ryujinx.android")
        )

        private val KNOWN_EMULATORS = PLATFORM_EMULATORS.values.flatten()
            .union(RETROARCH)
            .toSet()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "listEmulators" -> result.success(installedEmulators())
            "launch" -> launch(call, result)
            else -> result.notImplemented()
        }
    }

    private fun launch(call: MethodCall, result: MethodChannel.Result) {
        val romPath = call.argument<String>("romPath")
        val platform = call.argument<String>("platform") ?: "unknown"
        val preferred = call.argument<String>("package")
        val args = call.argument<String>("args")

        if (romPath.isNullOrBlank()) {
            result.error("INVALID_ARGS", "romPath is required", null)
            return
        }

        val pkg = preferred?.takeIf { isInstalled(it) } ?: firstInstalledFor(platform)
        if (pkg == null) {
            result.error("NO_EMULATOR", "No emulator installed for platform '$platform'", null)
            return
        }

        return try {
            launchEmulator(pkg, romPath, args)
            result.success(pkg)
        } catch (e: Exception) {
            result.error("LAUNCH_FAILED", e.message, null)
        }
    }

    private fun launchEmulator(pkg: String, romPath: String, args: String?) {
        val file = File(romPath)
        val intent = Intent(Intent.ACTION_VIEW)
        intent.setDataAndType(Uri.fromFile(file), "application/octet-stream")
        intent.setPackage(pkg)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
        intent.putExtra("rom", romPath)
        intent.putExtra("path", romPath)
        intent.putExtra("ROM", romPath)
        if (!args.isNullOrBlank()) {
            intent.putExtra("args", args)
        }

        // Front-ends traditionally exchange file:// URIs with emulators; relax the
        // strict-mode file URI exposure guard so the handoff does not crash.
        StrictMode.setVmPolicy(StrictMode.VmPolicy.LAX)
        context.startActivity(intent)
    }

    private fun installedEmulators(): List<String> =
        KNOWN_EMULATORS.filter { isInstalled(it) }

    private fun firstInstalledFor(platform: String): String? {
        val candidates = PLATFORM_EMULATORS[platform] ?: RETROARCH
        return candidates.firstOrNull { isInstalled(it) }
    }

    private fun isInstalled(pkg: String): Boolean = try {
        context.packageManager.getPackageInfo(pkg, 0)
        true
    } catch (e: PackageManager.NameNotFoundException) {
        false
    }
}
