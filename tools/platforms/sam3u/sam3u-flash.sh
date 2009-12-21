#!/bin/bash

openocd -s /usr/local/lib/openocd/ -f interface/olimex-arm-usb-ocd.cfg -f board/atmel_sam3u_ek.cfg &

sleep 2

arm-none-eabi-gdb build/sam3u_ek/main.exe -x $TOSROOT/tools/platforms/sam3u/flash.gdb

killall openocd
