#!/bin/sh

if [ -z "$1" ]
then
	echo "Usage: ./run_tests.sh <DEVICE/DEVICE_ID>"
else
	flutter clean build
	flutter drive --target=test_driver/backendless_tests.dart --driver=test_driver/backendless_driver.dart -d $1
fi

