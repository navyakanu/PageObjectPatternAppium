#!/usr/bin/env bash
list12=$(emulator -list-avds)
echo "$list12"

IFS=$'\n' y=($list12)
for i in `seq 0 ${#y[@]-1}`
do
	 emulator -avd ${y[i]} &
done
echo 'Booting two devices'
nohup adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done; input keyevent 82'
echo 'Device booted'
Platform="android" mvn clean -Dtest=Runner test
adb devices | grep emulator | cut -f1 | while read line; do adb -s $line emu kill; done

exit 0
