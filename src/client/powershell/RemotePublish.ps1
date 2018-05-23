# Remote Publish

# Example : .\RemotePublish.ps1 "http://turric4n.no-ip.org:8989" "D:\ams.zip" "zip" "." "publish"

 param (
    [Parameter(Mandatory=$true)][string]$apipublishcontrol,
    [Parameter(Mandatory=$true)][string]$file,
    [Parameter(Mandatory=$true)][string]$filetype,
    [Parameter(Mandatory=$true)][System.IO.FileInfo]$destination,
    [Parameter(Mandatory=$true)][string]$action,
    [Parameter(Mandatory=$false)][switch]$cleanup,
    [Parameter(Mandatory=$false)][switch]$backup
 )

 $contenttype = "application/json"

class PublishJob
{
  [string]$file
  [string]$filetype
  [string]$destination
  [string]$action
  [boolean]$cleanup
  [boolean]$backup
}

Import-Module Microsoft.PowerShell.Utility

if ([System.IO.File]::Exists($File)) 
{
    $publish = New-Object PublishJob
    #Prepare JSON
    try {      
      $publish.File = [Convert]::ToBase64String([IO.File]::ReadAllBytes($file))
      $publish.Filetype = $filetype
      $publish.Destination = $destination.ToString()
      $publish.Action = $action
      $publish.Cleanup = $cleanup
      $publish.Backup = $backup
      $json = $publish | ConvertTo-Json
    } 
    catch {
       echo $_.Exception.Message
       echo "Error loading file"
       $LASTEXITCODE = 1  
	   exit
       #[Environment]::Exit($LASTEXITCODE)
    }

    try {
        if ($action -eq "publish"){
		    echo "Publishing " $serviceName " on Remote machine"
            $response = Invoke-WebRequest ($apipublishcontrol + "/publish")  -ContentType $contenttype -Method POST -Body $json -Verbose
        }
    }
    catch {
       echo $_.Exception.Message
       echo "Error sending file"
       $LASTEXITCODE = 1
       #[Environment]::Exit($LASTEXITCODE)
    }
}
else {
  echo $file + " not exist"
  $LASTEXITCODE = 1
}