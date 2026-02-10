-keep class com.hiennv.flutter_callkit_incoming.** { *; }

# Google Maps ProGuard rules
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }
-dontwarn com.google.android.gms.**

# Prevent crash on Android 12+
-keep class androidx.lifecycle.DefaultLifecycleObserver
