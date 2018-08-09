#!/bin/sh

APK_FILE=/app/platforms/android/build/outputs/apk/android-debug.apk
cd /app

gradle cdvBuildDebug  --init-script /usr/share/android-sdk-helper/init.gradle -b platforms/android/build.gradle
if [ -f $APK_FILE ]; then
   echo "Ok."
else
   echo "Test failed."
fi

rm $APK_FILE
cordova build android
if [ -f $APK_FILE ]; then
   echo "Ok."
else
   echo "Test failed."
fi
