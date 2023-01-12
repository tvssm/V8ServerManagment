$UserName=$var1
$UserPass=$var2
$FullName=$var3
$UserDescr=$var4
New-LocalUser $UserName -Password $UserPass -FullName $FullName -Description $UserDescr