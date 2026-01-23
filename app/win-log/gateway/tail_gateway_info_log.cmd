@echo off
powershell -Command "Get-Content  -Path "..\..\gateway\logs\gateway\gateway-info.log" -Encoding UTF8  -Wait"