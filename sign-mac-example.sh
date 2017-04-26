#!/bin/bash

jarsigner -verbose -keystore my-release-key.keystore "$1" alias_name

echo ""
echo ""
echo "Checking if APK is verified..."
jarsigner -verify "$1"

