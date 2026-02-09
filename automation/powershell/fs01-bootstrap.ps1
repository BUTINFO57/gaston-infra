# =============================================================================
# fs01-bootstrap.ps1 — Configuration initiale de FS01 (Windows Server 2022 Core)
# Source : Runbook §4.5
# Exécuter depuis : PowerShell local sur FS01
# =============================================================================

#Requires -RunAsAdministrator

param(
    [string]$Hostname    = "FS01",
    [string]$IPAddress   = "192.168.10.111",
    [string]$Prefix      = "24",
    [string]$Gateway     = "192.168.10.1",
    [string]$DNS1        = "192.168.10.10",
    [string]$DNS2        = "192.168.10.9",
    [string]$Domain      = "gaston.local",
    [string]$DataDrive   = "D"
)

Write-Host "=== Bootstrap FS01 ===" -ForegroundColor Cyan

# --- 1. Renommer l'ordinateur ---
Write-Host "[1/6] Définition du nom d'hôte à $Hostname..."
Rename-Computer -NewName $Hostname -Force

# --- 2. Configuration réseau ---
Write-Host "[2/6] Configuration du réseau..."
$adapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1

# Supprimer l'IP existante
Get-NetIPAddress -InterfaceIndex $adapter.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue |
    Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue
Remove-NetRoute -InterfaceIndex $adapter.ifIndex -Confirm:$false -ErrorAction SilentlyContinue

# Définir l'IP statique
New-NetIPAddress -InterfaceIndex $adapter.ifIndex `
    -IPAddress $IPAddress `
    -PrefixLength $Prefix `
    -DefaultGateway $Gateway

# Définir le DNS
Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex `
    -ServerAddresses @($DNS1, $DNS2)

# Désactiver IPv6
Disable-NetAdapterBinding -Name $adapter.Name -ComponentID ms_tcpip6

Write-Host "[2/6] Réseau configuré : $IPAddress/$Prefix"

# --- 3. Initialiser le disque de données ---
Write-Host "[3/6] Initialisation du disque de données..."
$disk = Get-Disk | Where-Object { $_.PartitionStyle -eq "RAW" } | Select-Object -First 1
if ($disk) {
    $disk | Initialize-Disk -PartitionStyle GPT -PassThru |
        New-Partition -UseMaximumSize -DriveLetter $DataDrive |
        Format-Volume -FileSystem NTFS -NewFileSystemLabel "DATA" -Confirm:$false
    Write-Host "[3/6] Disque initialisé en ${DataDrive}:"
} else {
    Write-Host "[3/6] Aucun disque brut trouvé — ignoré" -ForegroundColor Yellow
}

# --- 4. Activer la gestion à distance ---
Write-Host "[4/6] Activation de la gestion à distance..."
Enable-PSRemoting -Force -SkipNetworkProfileCheck
winrm quickconfig -force
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

# --- 5. Mise à jour Windows ---
Write-Host "[5/6] Exécution de Windows Update..."
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue
Install-Module PSWindowsUpdate -Force -ErrorAction SilentlyContinue
Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue
# Get-WindowsUpdate -Install -AcceptAll -AutoReboot  # Uncomment when ready

# --- 6. Joindre le domaine ---
Write-Host "[6/6] Jonction au domaine $Domain..."
Write-Host "  Exécutez la commande suivante manuellement :"
Write-Host "  Add-Computer -DomainName $Domain -Credential (Get-Credential) -Restart" -ForegroundColor Yellow

Write-Host ""
Write-Host "=== Bootstrap terminé ===" -ForegroundColor Green
Write-Host "Après la jonction au domaine et le redémarrage, exécutez fs01-shares.ps1"
