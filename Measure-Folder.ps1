param (
   [string] $Path,
   [string] $OutFile = ".\Measure-Folder.csv",
   [switch] $Version
)
$ErrorActionPreference = 'SilentlyContinue'

$ProgramName = $MyInvocation.MyCommand.Name
$ProgramVersion = "1.0.26107"

if( $Version ) {
Write-host "$ProgramName`: $ProgramVersion"
exit 0
 }

$TotDirSize, $TotDirCount = 0
$dirlist = (get-childitem -path $Path -directory -recurse | Select-Object fullname).fullname
$parentDir = (get-item -path $Path |Select-Object fullname).fullname #3 Dec 2025 top level directory
write-output "Path, `"Object Count`", `"Size of Directory`"`n----,----,----" | Out-File -FilePath $OutFile

# 3 Dec 2025 - add in the count and sum of files in the parent directory
$dircount = 0
$dirsum = 0
$dircount = (get-childitem -path $parentDir |select-object count).count
$dirsum = (get-childitem -path $parentDir |measure-object -sum length | select-object sum).sum
write-output ("`"{0}`", `"{1}`", `"{2}`"" -f $parentDir, $dircount.ToString("#,###"), $dirsum.ToString("#,###")) | Out-File -FilePath $OutFile -Append
# 3 Dec 2025 - end adding in the count and sum of the objects in parent directory

foreach ( $dir in $dirlist ) {
	$dircount = 0
	$dirsum = 0
#   $dircount = (get-childitem -path "$dir" -recurse |select-object count).count
    $dircount = (get-childitem -path "$dir" |select-object count).count

#   $dirsum =(get-childitem -path "$dir" -recurse |measure-object -sum length | select-object sum).sum
   $dirsum =(get-childitem -path "$dir" |measure-object -sum length | select-object sum).sum

   # write-output "* $dir, $dircount, $dirsum"
   write-output ("`"{0}`", `"{1}`", `"{2}`"" -f $dir, $dircount.ToString("#,###"), $dirsum.ToString("#,###.##")) | Out-File -FilePath $OutFile -Append
}



<# PS C:\Users\gleng\OneDrive - TrendMicro\Documents\CXSE> Get-CimInstance -Class Win32_LogicalDisk |
>>     Select-Object -Property Name, @{
>>         Label='FreeSpace'
>>         Expression={($_.FreeSpace/1GB).ToString()}
>>     }

Name FreeSpace
---- ---------
C:   731.074825286865


PS C:\Users\gleng\OneDrive - TrendMicro\Documents\CXSE> Get-CimInstance -Class Win32_LogicalDisk |
>>     Select-Object -Property Name, @{
>>         Label='FreeSpace'
>>         Expression={($_.FreeSpace/1GB).ToString('F3')}
>>     }

Name FreeSpace
---- ---------
C:   731.075

#>