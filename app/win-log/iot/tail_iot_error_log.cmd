@echo off
powershell -Command "Get-Content  -Path "..\..\iot\logs\iot\iot-error.log" -Encoding UTF8  -Wait"