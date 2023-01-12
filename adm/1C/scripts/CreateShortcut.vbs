'јвтор скрипта “юрюков ¬ладимир —ергеевич, сайт: tvs-sm.ru, e-mail tvs-sm@ya.ru
'
Set oWS = WScript.CreateObject("WScript.Shell")
Set WshShell = WScript.CreateObject("WScript.Shell")
Set FSO=CreateObject("Scripting.FileSystemObject")

Set Args = WScript.Arguments

DesktopPath = WshShell.SpecialFolders("Desktop")
ScriptPath = FSO.GetParentFolderName(WScript.ScriptFullName)

if Args.Count() < 1 Then
   HelpMessage = "—крипту CreateShortcut.vbs нужны об€зательные параметры."&vbCrLf& _
   "¬се параметры задаютс€ в двойных кавычках"&vbCrLf& _
   "- 1й параметр путь к объекту €рлыка"&vbCrLf& _
   "- 2й параметр все параметры запуска в общих кавычках"&vbCrLf& _
   "- 3й параметр им€ €рлыка - если не указано им€ €рлыка будет = имени объекта €рлыка (из первого параметра)"&vbCrLf& _
   "- 4й путь к файлу иконки и ее  номер через зап€тую"&vbCrLf& _
   "- 5й путь к месту сохранени€ созданного €рлыка, если не задан то по умолчанию €рлык сохран€етс€ р€дом с этим скриптом. ≈сли передать %DESKTOP% то сохранит на рабочем столе текущего пользовател€."&vbCrLf& _
   ""&vbCrLf& _
   "ѕример запуска скрипта: "&vbCrLf& _
   "CreateShortcut.vbs ""D:\Adm\Sysinternals\Procmon64.exe"" ""/quiet /minimized"" ""ƒиспетчер задач x64"" "&vbCrLf& _
   "¬ыполнение текущего вызова скрипта прервано."

   MsgBox(HelpMessage)
   WScript.Quit
end if

'CreateShortcut.vbs "D:\Adm\Sysinternals\Procmon64.exe" "/quiet" "ƒиспетчер задач x64" "" %DESKTOP%

TargetLnkPath = Args.Item(0) '1й параметр путь к объекту €рлыка
Arguments = Args.Item(1)     '2й параметр параметры запуска в общих кавычках

FolderOfLinkedObject = FSO.GetParentFolderName(TargetLnkPath)
'MsgBox(TargetLnkPath)

if Args.Count() >= 3 and Args.Item(2) <> "" Then
   NameLink = Args.Item(2) '3й параметр им€ €рлыка  
else 'им€ €рлыка не задано
   NameLink = FSO.GetBaseName(FSO.GetFile(TargetLnkPath))
end if
MsgBox(NameLink)

if Args.Count() >= 4 and Args.Item(3) <> "" Then
   IconLocation = Args.Item(3) '4й путь к файлу иконки и ее  номер через зап€тую
else 'путь к иконке не задан используетс€ перва€ иконка из файла на который делаетс€ €рлык
   IconLocation = TargetLnkPath + ", 0"
end if

if Args.Count() >= 5 and Args.Item(4) <> "" Then '5й путь к месту сохранени€ созданного €рлыка, если не задан то по умолчанию €рлык сохран€етс€ р€дом с этим скриптом
   if Args.Item(4) = "%DESKTOP%" Then
      sLinkFile = DesktopPath + "\" + NameLink + ".lnk"
   else   
      sLinkFile = Args.Item(4) + "\" + NameLink + ".lnk"
   end if
else 
   sLinkFile = ScriptPath + "\" + NameLink + ".lnk"
end if
'MsgBox(sLinkFile)

Description = ""


Set oLink = oWS.CreateShortcut(sLinkFile)
    oLink.TargetPath = TargetLnkPath
   oLink.Arguments = Arguments
   oLink.Description = Description   
 '  oLink.HotKey = "ALT+CTRL+F"
   oLink.IconLocation = IconLocation
 '  oLink.WindowStyle = "1"   
   oLink.WorkingDirectory = FolderOfLinkedObject
oLink.Save
