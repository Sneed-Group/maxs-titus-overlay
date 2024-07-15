Write-Host "Removing bloatware, please wait..."

Try{

    $ExcludeApp = "1527c705-839a-4832-9118-54d4Bd6a0c89","c5e2524a-ea46-4f67-841f-6a9465d9d515","E2A4F912-2574-4A75-9BB0-0D023378592B","F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE","Microsoft.AAD.BrokerPlugin","Microsoft.AccountsControl","Microsoft.MicrosoftEdge.Stable","Microsoft.AsyncTextService","Microsoft.AV1VideoExtension","Microsoft.AVCEncoderVideoExtension","Microsoft.BioEnrollment","Microsoft.CredDialogHost","Microsoft.MicrosoftEdgeDevToolsClient","Microsoft.UI.Xaml.CBS","Microsoft.Win32WebViewHost","Microsoft.Windows.Apprep.ChxApp","Microsoft.Windows.AssignedAccessLockApp","Microsoft.Windows.CallingShellApp","Microsoft.Windows.CapturePicker","Microsoft.Windows.CloudExperienceHost","Microsoft.Windows.ContentDeliveryManager","Microsoft.DolbyAudioExtensions","Microsoft.Windows.NarratorQuickStart","Microsoft.Windows.OOBENetworkCaptivePortal","Microsoft.Windows.OOBENetworkConnectionFlow","Microsoft.Windows.PeopleExperienceHost","Microsoft.Windows.ParentalControls","Microsoft.Windows.PinningConfirmationDialog","Microsoft.Windows.PrintQueueActionCenter","Microsoft.Windows.SecureAssessmentBrowser","Microsoft.Windows.StartMenuExperienceHost","Microsoft.Windows.XGpuEjectDialog","Microsoft.WindowsAppRuntime.CBS","Microsoft.XboxGameCallableUI","MicrosoftWindows.Client.Core","MicrosoftWindows.Client.FileExp","MicrosoftWindows.UndockedDevKit","NcsiUwpApp","Windows.CBSPreview","windows.immersivecontrolpanel","Windows.PrintDialog","Microsoft.UI.Xaml.2.4","Microsoft.VCLibs.140.00","Microsoft.NET.Native.Runtime.2.2","Microsoft.NET.Native.Framework.2.2","Microsoft.DesktopAppInstaller","Microsoft.HEIFImageExtension","Microsoft.HEVCVideoExtension","Microsoft.MPEG2VideoExtension","Microsoft.RawImageExtension","Microsoft.ScreenSketch","Microsoft.StorePurchaseApp","Microsoft.VP9VideoExtensions","Microsoft.WebMediaExtensions","Microsoft.WebpImageExtension","Microsoft.WindowsCalculator","Microsoft.WindowsNotepad","Microsoft.WindowsTerminal","Microsoft.SecHealthUI","Microsoft.VCLibs.140.00.UWPDesktop","Microsoft.WindowsAppRuntime.1.5","Microsoft.UI.Xaml.2.8","Microsoft.VCLibs.140.00","Microsoft.NET.Native.Runtime.2.2","Microsoft.NET.Native.Framework.2.2","Microsoft.Paint","Microsoft.WindowsStore","Microsoft.UI.Xaml.2.7","MicrosoftWindows.Client.LKG","Microsoft.WindowsAppRuntime.CBS","MicrosoftWindows.Client.Core","Microsoft.ECApp","Microsoft.LockApp","Microsoft.Windows.ShellExperienceHost","MicrosoftWindows.Client.CBS","Microsoft.Windows.AugLoop.CBS","MicrosoftWindows.Client.AIX","MicrosoftWindows.Client.Core","MicrosoftWindows.Client.FileExp","MicrosoftWindows.Client.OOBE","MicrosoftWindows.Client.Photon"

    $GetAppExclude = Get-AppxPackage -AllUsers | Select Name | Where Name -notin $ExcludeApp
    $GetAppExcludeV2 = $GetAppExclude.Name -notlike 'Microsoft.WindowsAppRuntime*' -notlike 'Microsoft.LanguageExperiencePack*' -notlike 'Microsoft.ApplicationCompatibilityEnhancements' -notlike 'Microsoft.Services.Store.Engagement'

    ForEach ($App in $GetAppExcludeV2){
        Get-AppxPackage -AllUsers $App | Remove-AppPackage
    }

    $DISMExcludeApp = "Microsoft.ApplicationCompatibilityEnhancements","Microsoft.AV1VideoExtension","Microsoft.AVCEncoderVideoExtension","Microsoft.DesktopAppInstaller","Microsoft.DolbyAudioExtensions","Microsoft.HEIFImageExtension","Microsoft.HEVCVideoExtension","Microsoft.MPEG2VideoExtension","Microsoft.MicrosoftEdge.Stable","Microsoft.NET.Native.Framework.2.2","Microsoft.NET.Native.Runtime.2.2","Microsoft.Paint","Microsoft.RawImageExtension","Microsoft.ScreenSketch","Microsoft.SecHealthUI","Microsoft.Services.Store.Engagement","Microsoft.StorePurchaseApp","Microsoft.UI.Xaml.2.7","Microsoft.UI.Xaml.2.8","Microsoft.VCLibs.140.00","Microsoft.VCLibs.140.00.UWPDesktop","Microsoft.VP9VideoExtensions","Microsoft.WebMediaExtensions","Microsoft.WebpImageExtension","Microsoft.WindowsCalculator","Microsoft.WindowsNotepad","Microsoft.WindowsAppRuntime.1.3","Microsoft.WindowsAppRuntime.1.4","Microsoft.WindowsStore","Microsoft.WindowsTerminal"

    $GetDISMAppExclude = Get-ProvisionedAppxPackage -Online | Select DisplayName,PackageName | Where DisplayName -notin $DISMExcludeApp

    ForEach ($App in $GetDISMAppExclude.PackageName){
        dism /Online /Remove-ProvisionedAppxPackage /PackageName:$App
    }

    Clear-Host
    Write-Host "Bloatware removal completed" -ForegroundColor Green

}
Catch{

    Write-Host "Bloatware removal failed. An error has been detected : $($_.Exception.Message)." -ForegroundColor Red

}

Write-Host "Removing OneDrive, please wait..."

Try{

    #Stop OneDrive process
    ps onedrive | Stop-Process -Force

    If (Test-Path -Path "$env:windir\SysWOW64\OneDriveSetup.exe" -PathType Leaf) {
        Start-process "$env:windir\SysWOW64\OneDriveSetup.exe" "/uninstall"
    }
    Else {
        Start-process "$env:windir\System32\OneDriveSetup.exe" "/uninstall"
    }
    
    #Find local administrator
    $GetAdminSID = Get-LocalGroup -SID "S-1-5-32-544"
    $Admin = $GetAdminSID.Name

    #Assigning rights to the appdata folder and deleting it
    $OneDriveLocation = "$env:localappdata\Microsoft\OneDrive"
    $ACL = Get-ACL $OneDriveLocation
    $Group = New-Object System.Security.Principal.NTAccount("BUILTIN", "$Admin")
    $ACL.SetOwner($Group)
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\$Admin", "FullControl", "Allow")
    $ACL.SetAccessRule($AccessRule)
    Set-Acl $OneDriveLocation -AclObject $ACL

    #Assigning rights to the appdata folder and deleting it
    If (Test-Path -Path "$env:windir\SysWOW64\OneDriveSetup.exe" -PathType Leaf) {
        $OneDriveSystemLocation = "$env:windir\SysWOW64\OneDriveSetup.exe"
    }
    Else {
        $OneDriveSystemLocation = "$env:windir\System32\OneDriveSetup.exe"
    }
    $ACL = Get-ACL $OneDriveSystemLocation
    $Group = New-Object System.Security.Principal.NTAccount("BUILTIN", "$Admin")
    $ACL.SetOwner($Group)
    $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\$Admin", "FullControl", "Allow")
    $ACL.SetAccessRule($AccessRule)
    Set-Acl $OneDriveSystemLocation -AclObject $ACL

    #Block explorer from restart from itself then kill explorer
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoRestartShell -Value 0
    Stop-Process -ProcessName explorer -Force

    Start-Sleep 5

    Remove-Item -Path "$env:localappdata\Microsoft\OneDrive" -Recurse -Force

    If (Test-Path -Path "$env:windir\SysWOW64\OneDriveSetup.exe" -PathType Leaf) {
        Remove-Item "$env:windir\SysWOW64\OneDriveSetup.exe" -Force
    }
    Else {
        Remove-Item  "$env:windir\System32\OneDriveSetup.exe" -Force
    }

    #Restore registry key and restart explorer
    Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoRestartShell -Value 1
    Start explorer.exe

    Clear-Host
    Write-Host "OneDrive removal completed" -ForegroundColor Green

}
Catch{

    Write-Host "OneDrive removal failed. An error has been detected : $($_.Exception.Message)." -ForegroundColor Red

}

# Activate Windows 11 via MAS HWID Activation


# Define the URL from which to download the batch file
$url = "https://github.com/massgravel/Microsoft-Activation-Scripts/raw/master/MAS/Separate-Files-Version/Activators/HWID_Activation.cmd"

# Define where you want to save the downloaded file
$output = "C:\hwid_activate.cmd"

# Download the file using PowerShell's Invoke-WebRequest cmdlet
Invoke-WebRequest -Uri $url -OutFile $output

# Check if the file was downloaded successfully
if (Test-Path $output) {
    # If downloaded successfully, execute the batch file
    Start-Process -FilePath $output
} else {
    Write-Host "Failed to download the batch file."
}
