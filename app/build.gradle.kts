plugins {
    id("com.android.application")
    id("kotlin-android")
}

android {
    namespace = "com.example.sensorapp"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.sensorapp"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    // Ensure Java compatibility
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    // Kotlin options
    kotlinOptions {
        jvmTarget = "1.8"
    }

    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.4.8" // match a stable Compose version
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
        }
    }
}

dependencies {
    // Compose BOM (choose a stable version, e.g. 2023.08.00)
    implementation(platform("androidx.compose:compose-bom:2023.08.00"))

    // Core Compose libs
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.material:material")
    implementation("androidx.compose.material3:material3")

    // For Compose preview & debugging
    debugImplementation("androidx.compose.ui:ui-tooling")
    debugImplementation("androidx.compose.ui:ui-test-manifest")

    // Activity Compose
    implementation("androidx.activity:activity-compose:1.7.2")

    // Kotlin stdlib
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.8.0")

    // If you want to test location or S3 (like your original code)
    // (You can remove these if not needed)
    // implementation("com.google.android.gms:play-services-location:21.0.1")
    // implementation("com.amazonaws:aws-android-sdk-core:2.57.0")
    // implementation("com.amazonaws:aws-android-sdk-s3:2.57.0")
    // implementation("com.opencsv:opencsv:5.7.1")

    // etc.
}
