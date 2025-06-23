# ===== Razorpay SDK Keep Rules =====
-keep class com.razorpay.** { *; }
-keep interface com.razorpay.** { *; }

# Handle missing annotations that cause R8 failure
-keep class proguard.annotation.Keep { *; }
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers

# Avoid warnings from R8
-dontwarn com.razorpay.**
