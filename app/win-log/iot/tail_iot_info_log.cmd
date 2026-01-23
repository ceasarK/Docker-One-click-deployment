@echo off
powershell -Command "Get-Content  -Path "..\..\iot\logs\iot\iot-info.log" -Encoding UTF8  -Wait"