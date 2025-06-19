# Get-AppxPackage, Get-AppxProvisionedPackage

Write-Output "     AppxPackages"
Write-Output "======================"

#Get-AppxPackage -AllUsers
Get-AppxPackage -Allusers * | Select Name, PackageFullName

#Get-AppxPackage *Windows.DevHome* | Remove-AppxPackage
#Get-AppxPackage -AllUsers -PackageTypeFilter Bundle -Name "*Windows.DevHome*" | Remove-AppxPackage
#Get-appxProvisionedPackage -online | where-object {$_.packagename -like '*Windows.DevHome*'} | remove-appxprovisionedpackage -online  

Write-Output "AppxProvisionedPackages"
Write-Output "======================="

Get-AppxProvisionedPackage -online | select PackageName

#Get-AppxProvisionedpackage –online | where-object {$_.packagename –like “*xbox*”} | Remove-AppxProvisionedPackage -online
#Get-AppxProvisionedpackage –online | where-object {$_.packagename –notlike “*store*”} | Remove-AppxProvisionedPackage -online
#Remove-AppxProvisionedPackage -online -packagename <string>
