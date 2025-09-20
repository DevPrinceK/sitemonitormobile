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
    // Upgraded AGP to 8.6.0 to align with latest plugin/tooling requirements
    id("com.android.application") version "8.6.0" apply false
    // Kotlin 2.1.0 for compatibility with AGP 8.6.x and newer language features
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
