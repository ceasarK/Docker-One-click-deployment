@echo off
powershell -Command "Get-Content  -Path "..\..\test-rig\logs\test-rig\test-rig-info.log" -Encoding UTF8 -Tail 100  -Wait"