# Remote task manager


 param (
    [Parameter(Mandatory=$true)][string]$apiprocesscontrol,
    [Parameter(Mandatory=$true)][string]$serviceName,
	[Parameter(Mandatory=$true)][string]$type,
    [Parameter(Mandatory=$true)][string]$action,    
	[Parameter(Mandatory=$false)][string]$parameters
 )

 $contenttype = "application/json"

class PublishJob
{
  [string]$processname
  [string]$processtype
  [string]$parameters
  [string]$action
}

$publish = New-Object PublishJob
$publish.processname = $serviceName
$publish.processtype = $type
$publish.parameters = $parameters
$publish.action = $action

$json = $publish | ConvertTo-Json

try {
    if ($action -eq "start"){
		echo "Starting " $serviceName " on Remote machine"
        $response = Invoke-WebRequest ($apiprocesscontrol + "/process")  -ContentType $contenttype -Method POST -Body $json
    }
    elseif ($action -eq "stop"){
        echo "Stopping " $serviceName " on Remote machine"
        $response = Invoke-WebRequest ($apiprocesscontrol + "/process") -ContentType $contenttype -Method POST -Body $json
    }
    else {
        throw "Action not supported" 
    }

    sleep(5)
    
}
catch {
   echo $_.Exception.Message
   echo "Error stopping service"
   $LASTEXITCODE = 1
}