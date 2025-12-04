param (
   [string] $Path,
   [string] $OutFile = ".\Measure-Folder.csv"
)
$ErrorActionPreference = 'SilentlyContinue'

$TotDirSize, $TotDirCount = 0
$dirlist = (get-childitem -path $Path -directory -recurse | Select-Object fullname).fullname
$parentDir = (get-item -path $Path |Select-Object fullname).fullname #3 Dec 2025 top level directory
write-output "Path, Object Count, Size of Directory" | Out-File -FilePath $OutFile

# 3 Dec 2025 - add in the count and sum of files in the parent directory
$dircount = 0
$dirsum = 0
$dircount = (get-childitem -path $parentDir |select-object count).count
$dirsum = (get-childitem -path $parentDir |measure-object -sum length | select-object sum).sum
write-output "----,----,----`n$parentDir, $dircount, $dirsum" | Out-File -FilePath $OutFile -Append
# 3 Dec 2025 - end adding in the count and sum of the objects in parent directory

foreach ( $dir in $dirlist ) {
	$dircount = 0
	$dirsum = 0
#   $dircount = (get-childitem -path "$dir" -recurse |select-object count).count
    $dircount = (get-childitem -path "$dir" |select-object count).count

#   $dirsum =(get-childitem -path "$dir" -recurse |measure-object -sum length | select-object sum).sum
   $dirsum =(get-childitem -path "$dir" |measure-object -sum length | select-object sum).sum

   write-output "$dir, $dircount, $dirsum" | Out-File -FilePath $OutFile -Append
}
