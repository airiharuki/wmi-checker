# Get basic system info
$os = Get-WmiObject Win32_OperatingSystem
$cpu = Get-WmiObject Win32_Processor
$wmiMonitor = Get-WmiObject Win32_DesktopMonitor

# Get disk drives
$drives = Get-Disk | Where-Object {$_.DriveType -eq "Fixed"}

# Count online drives
$onlineDrives = $drives | Where-Object {$_.Status -eq "Online"} | Measure-Object | Select-Object Count

# Format the data for display
$osName = $os.Caption
$osVersion = $os.Version
$cpuModel = $cpu.Name
$cpuCores = $cpu.NumberOfCores
$monitorName = $wmiMonitor.Manufacturer + " " + $wmiMonitor.ModelName
$ramSize = (Get-WmiObject Win32_PhysicalMemory).Capacity / 1GB | Measure-Object -Sum | Select-Object Sum

# Build the fancy output
$output = @"

       
        
                                    ....iilll
                          ....iilllllllllllll
              ....iillll  lllllllllllllllllll
          iillllllllllll  lllllllllllllllllll
          llllllllllllll  lllllllllllllllllll
          llllllllllllll  lllllllllllllllllll
          llllllllllllll  lllllllllllllllllll
          llllllllllllll  lllllllllllllllllll         WINDOWS-INFO-DUMPER (WID) V1.0.0
          llllllllllllll  lllllllllllllllllll         Copyrighted : 2024 BY ME
                                                      Made by SomBokM3as
         llllllllllllll  lllllllllllllllllll
         llllllllllllll  lllllllllllllllllll
         llllllllllllll  lllllllllllllllllll
         llllllllllllll  lllllllllllllllllll
         llllllllllllll  lllllllllllllllllll
         `^^^^^^lllllll  lllllllllllllllllll
               ````^^^^  ^^lllllllllllllllll
                              ````^^^^^^llll
                              
           Windows ($osName $osVersion)

           CPU: $cpuModel ($cpuCores Cores)
           RAM: $ramSize GB
           Display: $monitorName
           Drives: $($onlineDrives.Count) Online

"@

# Add drive information with simple icons
$driveOutput = ""
foreach ($drive in $drives) {
  if ($drive.Status -eq "Online") {
    $driveOutput += "  $drive.DriveLetter:   ($drive.Size / 1GB)GB\n"
  }
}
$output += $driveOutput

# Display the output
Write-Host $output
