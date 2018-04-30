# Remote Publish

 param (
    [Parameter(Mandatory=$true)][string]$apipublishcontrol,
    [Parameter(Mandatory=$true)][string]$file,
    [Parameter(Mandatory=$true)][string]$filetype,
    [Parameter(Mandatory=$true)][System.IO.FileInfo]$destination,
    [Parameter(Mandatory=$true)][string]$action
 )

 $contenttype = "application/json"

class PublishJob
{
  [string]$file
  [string]$filetype
  [string]$destination
  [string]$action
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
            $response = Invoke-WebRequest ($apipublishcontrol + "/publish")  -ContentType $contenttype -Method POST -Body $json -TimeoutSec 10000
        }
    }
    catch {
       echo $_.Exception.Message
       echo "Error stopping service"
       $LASTEXITCODE = 1
       #[Environment]::Exit($LASTEXITCODE)
    }
}
else {
  echo $file + " not exist"
  $LASTEXITCODE = 1
}