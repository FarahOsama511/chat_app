# Suppress warnings for missing logger binder from Pusher / slf4j
-dontwarn org.slf4j.**
-dontwarn org.slf4j.impl.StaticLoggerBinder

# Pusher
-keep class com.pusher.** { *; }
-dontwarn com.pusher.**
