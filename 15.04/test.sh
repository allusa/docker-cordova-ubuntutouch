#!/bin/sh

cd /app
echo "Y" | cordova -d build --device -- --framework=ubuntu-sdk-15.04

CLICK_FILE=platforms/ubuntu/ubuntu-sdk-15.04/armhf/prefix/io.cordova.hellocordova_1.0.0_armhf.click 
if [ -f $CLICK_FILE ]; then
   echo "Ok."
else
   echo "Test failed."
fi
