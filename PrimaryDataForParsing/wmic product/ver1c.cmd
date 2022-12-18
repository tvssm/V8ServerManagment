chcp 65001
wmic  product where "vendor='1С-Софт' and name like '%Предприятие 8%'" get InstallLocation, Version, Name, Vendor >> C:\Users\tvs-s\AppData\Local\Temp\v8_F30F_8.txt
pause
