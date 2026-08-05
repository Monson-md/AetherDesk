pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // Pinned below AGP 9 deliberately: AGP 9's "built-in Kotlin" migration is
    // not yet consistent across the plugin ecosystem — Flutter's own
    // flutter-plugin-loader force-applies the legacy Kotlin Android plugin
    // to any Android library subproject that doesn't declare Kotlin Gradle
    // Plugin itself (e.g. flutter_plugin_android_lifecycle), which AGP 9's
    // built-in Kotlin then rejects as redundant — a hard build failure
    // regardless of the android.builtInKotlin gradle.properties flag.
    // AGP 8.7.x + Kotlin 2.1.x is the well-established, broadly compatible
    // combination the current generation of Flutter plugins is built
    // against.
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
