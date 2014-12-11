echo OFF
title DeadElf79's Gource Launcher
color 0A
echo Select resolution:
echo 1. 640x480
echo 2. 800x600
echo 3. 1024x768
echo 4. 1280x1024
echo 5. 1600x1200
echo 6. 1920x1080
set /P GOURCERESOLUTION=Enter here:
if %GOURCERESOLUTION% gtr 0 (
	goto answer%GOURCERESOLUTION%
)

:answer1
gource -640x480 -f --multi-sampling --default-user-image deadelf79.png --seconds-per-day 1 --logo logoCIGUI.png
:answer2
gource -800x600 -f --multi-sampling --default-user-image deadelf79.png --seconds-per-day 1 --logo logoCIGUI.png
:answer3
gource -1024x768 -f --multi-sampling --default-user-image deadelf79.png --seconds-per-day 1 --logo logoCIGUI.png
:answer4
gource -1280x1024 -f --multi-sampling --default-user-image deadelf79.png --seconds-per-day 1 --logo logoCIGUI.png
:answer5
gource -1600x1200 -f --multi-sampling --default-user-image deadelf79.png --seconds-per-day 1 --logo logoCIGUI.png
:answer6
gource -1920x1080 -f --multi-sampling --default-user-image deadelf79.png --seconds-per-day 1 --logo logoCIGUI.png