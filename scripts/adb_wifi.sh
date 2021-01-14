#!/bin/bash

sudo adb kill-server
sudo adb start-server
sudo adb tcpip 5555
# adb shell ip addr show wlan0
sudo adb connect 192.168.88.167:5555
