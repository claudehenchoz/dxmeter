param(
    [string]$meter,
    [int]$count = 1
)

$dateFormat = "yyyy-MM-ddTHH:mm:ss.fffffffZ" # ISO 8601

$startDate = Get-Date
$startDateString = Get-Date $startDate -Format $dateFormat

$meters = @()

for ($i = 1; $i -le $count; $i++) {
    
    if (Test-Path "meters\$meter.ps1") {

        Write-Output "$startDateString`: Starting $meter"

        $startDate = Get-Date
        . "meters\$meter.ps1"
        $endDate = Get-Date
    
        $elapsedTime = New-TimeSpan $startDate $endDate
    
        $meterdata = [PSCustomObject] @{
            Name        = $meter
            Seconds     = $elapsedTime.TotalSeconds
            Timestamp   = Get-Date $startDate -Format $dateFormat
            ComputerName= $env:COMPUTERNAME
            CPU         = (Get-WmiObject win32_processor).Name.Trim()
            CPU_Speed   = (Get-WmiObject Win32_Processor).MaxClockSpeed
            CPU_Cores   = (Get-WmiObject Win32_Processor).NumberOfCores
            RAM         = [math]::Round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory /1024/1024/1024)
            Model       = (Get-WmiObject Win32_ComputerSystem).Model
        }
    
        $meterdata | Export-Csv -NoClobber -NoTypeInformation "runs.csv" -Append
        $meterdata | Format-Table
        $meters += $meterdata

    }
    else {
        Write-Host "File meters\$meter.ps1 does not exist"
        Write-Host "The following meters are available:"
        Get-ChildItem -Path ".\meters" -Filter "*.ps1" | Where-Object { $_.Name -notlike "*_prereq*" } | ForEach-Object { $_.Name -replace '\.ps1$' }
        break
    }
}

$meters | Format-Table
