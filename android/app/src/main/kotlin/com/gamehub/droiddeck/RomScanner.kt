package com.gamehub.droiddeck

import android.content.Context
import android.os.Environment
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Asynchronous ROM scanner across internal storage and mounted MicroSD cards.
 */
class RomScanner(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "com.gamehub/rom_scanner"
        private const val MAX_DEPTH = 6

        private val ROM_EXTENSIONS = setOf(
            // Nintendo
            "nes", "unf", "unif", "fds",
            "smc", "sfc", "swc", "fig",
            "n64", "z64", "v64",
            "gb", "gbc", "gba",
            "nds", "dsi", "3ds", "cia", "cci", "cxi",
            "wad", "rvz", "wbfs", "gcm", "dol",
            "nsp", "xci",
            // Sega
            "md", "gen", "smd", "32x", "sms", "gg",
            // Sony
            "pbp", "cso", "chd", "iso", "elf", "prx",
            // NEC / SNK / Atari / Arcade
            "pce", "sgx", "a26", "a52", "a78", "ngp", "ngc",
            // Disc images / generic
            "cue", "gdi", "cdi", "bin", "zip", "7z"
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "discoverRoots" -> result.success(discoverRoots())
            "scan" -> scanAsync(call, result)
            else -> result.notImplemented()
        }
    }

    private fun scanAsync(call: MethodCall, result: MethodChannel.Result) {
        val requested = call.argument<List<String>>("roots")
        val roots = if (!requested.isNullOrEmpty()) requested else discoverRoots()
        val mainHandler = Handler(Looper.getMainLooper())

        Thread {
            val found = ArrayList<Map<String, Any?>>()
            for (root in roots) {
                try {
                    walk(File(root), found, 0)
                } catch (e: SecurityException) {
                    // Skip unreadable volume.
                }
            }
            mainHandler.post { result.success(found) }
        }.start()
    }

    private fun discoverRoots(): List<String> {
        val roots = LinkedHashSet<String>()

        Environment.getExternalStorageDirectory()?.let { roots.add(it.absolutePath) }

        for (dir in context.getExternalFilesDirs(null)) {
            if (dir == null) continue
            val path = dir.absolutePath.substringBefore("/Android/data")
            if (path.startsWith("/storage")) roots.add(path)
        }

        // Common removable-media mount points.
        roots.add("/storage/emulated/0")

        return roots.filter { File(it).exists() }
    }

    private fun walk(dir: File, out: MutableList<Map<String, Any?>>, depth: Int) {
        if (depth > MAX_DEPTH) return

        val children = try {
            dir.listFiles()
        } catch (e: SecurityException) {
            null
        } ?: return

        for (child in children) {
            if (child.isDirectory) {
                val name = child.name
                if (name == "Android" || name == "obb" || name.startsWith(".")) continue
                walk(child, out, depth + 1)
            } else {
                val ext = child.extension.lowercase()
                if (ROM_EXTENSIONS.contains(ext)) {
                    out.add(
                        mapOf(
                            "path" to child.absolutePath,
                            "name" to child.nameWithoutExtension,
                            "extension" to ext,
                            "size" to child.length()
                        )
                    )
                }
            }
        }
    }
}
