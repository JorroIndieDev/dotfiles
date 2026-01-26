#!/usr/bin/env bash

## Original Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
# Available themes are the files you put under the ./custon-styles folder
# Follow the default theme to see how to use it integrated with the pywal generated variables

dir="$HOME/.config/rofi/custom-theme/custom-styles"
theme='custom-default'

## Run
rofi \
    -show drun \
    -theme ${dir}/${theme}.rasi
