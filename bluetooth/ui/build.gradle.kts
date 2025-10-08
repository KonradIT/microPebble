plugins {
   androidLibraryModule
   compose
   di
   navigation
   showkase
}

android {
   namespace = "com.matejdro.micropebble.bluetooth.ui"

   buildFeatures {
      androidResources = true
   }
}

dependencies {
   api(projects.bluetooth.api)
   api(projects.commonNavigation)
   api(projects.common)
   api(projects.notification.api)
   api(libs.kotlinova.navigation)

   implementation(projects.commonCompose)
   implementation(projects.sharedResources)
   implementation(libs.androidx.core)
   implementation(libs.accompanist.permissions)
   implementation(libs.androidx.activity.compose)
   implementation(libs.libpebble3)
   implementation(libs.kotlin.coroutines)
   implementation(libs.kotlinova.core)
}
