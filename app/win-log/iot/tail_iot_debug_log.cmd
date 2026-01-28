@echo off
powershell -Command "Get-Content  -Path "..\..\iot\logs\iot\iot-debug.log" -Encoding UTF8 -Tail 100  -Wait"