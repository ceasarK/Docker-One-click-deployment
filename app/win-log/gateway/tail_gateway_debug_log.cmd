@echo off
powershell -Command "Get-Content  -Path "..\..\gateway\logs\gateway\gateway-debug.log" -Encoding UTF8  -Wait"