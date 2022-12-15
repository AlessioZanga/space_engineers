#!/bin/bash

Xvfb :5 -screen 0 1024x768x16 &

WINEDLLOVERRIDES="mscoree=d" wineboot --init /nogui
winetricks corefonts
winetricks sound=disabled
DISPLAY=:5.0 winetricks -q vcrun2019
DISPLAY=:5.0 winetricks -q --force dotnet48
