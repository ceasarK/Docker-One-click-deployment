@echo off
powershell -Command "Get-Content  -Path "..\..\test-rig\logs\test-rig\test-rig-debug.log" -Encoding UTF8  -Wait"