#!/bin/bash

arm-none-eabi-nm --numeric-sort --print-size build/sam3u_ek/main.exe | view -
