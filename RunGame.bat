@echo off
echo On the next screen, click singleplayer.html
ping -n 4 localhost>nul
localhost.url
http-server -c-1