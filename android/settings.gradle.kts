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
    // 8.11.1/2.2.20 (with Gradle 8.14.2 in gradle-wrapper.properties) are
    // the minimums `flutter build` itself reports as required by current
    // androidx dependencies and by Flutter's own deprecation warnings.
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    // Étape 2: processes android/app/google-services.json at build time so
    // Firebase.initializeApp() has real config to read (see firebase_core
    // comment in pubspec.yaml) — must be declared here and applied in
    // android/app/build.gradle.kts.
    id("com.google.gms.google-services") version "4.4.4" apply false
}

include(":app")
