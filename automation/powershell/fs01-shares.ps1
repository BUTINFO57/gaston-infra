# =============================================================================
# fs01-shares.ps1 — Création des partages SMB + ACL NTFS sur FS01
# Source : Runbook §4.5.6
# Prérequis : FS01 joint à gaston.local, lecteur D: formaté
# Exécuter depuis : PowerShell local sur FS01
# =============================================================================

#Requires -RunAsAdministrator

param(
    [string]$DataRoot = "D:\Shares",
    [string]$Domain   = "GASTON"
)

Write-Host "=== Configuration des partages FS01 ===" -ForegroundColor Cyan

# --- Définition des partages ---
$shares = @(
    @{ Name = "Direction";    Group = "DL_Direction_RW";    GroupRO = "DL_Direction_RO" },
    @{ Name = "Comptabilite"; Group = "DL_Comptabilite_RW"; GroupRO = "DL_Comptabilite_RO" },
    @{ Name = "RH";           Group = "DL_RH_RW";           GroupRO = "DL_RH_RO" },
    @{ Name = "Production";   Group = "DL_Production_RW";   GroupRO = "DL_Production_RO" },
    @{ Name = "Vente";        Group = "DL_Vente_RW";        GroupRO = "DL_Vente_RO" },
    @{ Name = "Marketing";    Group = "DL_Marketing_RW";    GroupRO = "DL_Marketing_RO" },
    @{ Name = "Logistique";   Group = "DL_Logistique_RW";   GroupRO = "DL_Logistique_RO" }
)

# --- Common share ---
$commonShare = @{
    Name  = "Commun"
    Group = "DL_Commun_RW"
}

# --- Créer le répertoire de base ---
if (-not (Test-Path $DataRoot)) {
    New-Item -ItemType Directory -Path $DataRoot -Force | Out-Null
}

# --- Créer les partages par département ---
foreach ($share in $shares) {
    $path = Join-Path $DataRoot $share.Name
    Write-Host "[+] Création du partage : $($share.Name)..." -ForegroundColor Green

    # Créer le dossier
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }

    # Réinitialiser les ACL NTFS (désactiver l'héritage, supprimer les héritées)
    $acl = Get-Acl $path
    $acl.SetAccessRuleProtection($true, $false)

    # Ajouter SYSTEM Contrôle total
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "NT AUTHORITY\SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)

    # Ajouter Admins du domaine Contrôle total
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "$Domain\Domain Admins", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)

    # Ajouter le groupe RW — Modification
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "$Domain\$($share.Group)", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)

    # Ajouter le groupe RO — Lecture
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "$Domain\$($share.GroupRO)", "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.AddAccessRule($rule)

    Set-Acl $path $acl

    # Créer le partage SMB
    if (-not (Get-SmbShare -Name $share.Name -ErrorAction SilentlyContinue)) {
        New-SmbShare -Name $share.Name -Path $path `
            -FullAccess "$Domain\Domain Admins" `
            -ChangeAccess "$Domain\$($share.Group)" `
            -ReadAccess "$Domain\$($share.GroupRO)" `
            -Description "Partage $($share.Name)"
    }
}

# --- Partage commun ---
$commonPath = Join-Path $DataRoot $commonShare.Name
Write-Host "[+] Création du partage : $($commonShare.Name)..." -ForegroundColor Green

if (-not (Test-Path $commonPath)) {
    New-Item -ItemType Directory -Path $commonPath -Force | Out-Null
}

$acl = Get-Acl $commonPath
$acl.SetAccessRuleProtection($true, $false)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "NT AUTHORITY\SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "$Domain\Domain Admins", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "$Domain\$($commonShare.Group)", "Modify", "ContainerInherit,ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl $commonPath $acl

if (-not (Get-SmbShare -Name $commonShare.Name -ErrorAction SilentlyContinue)) {
    New-SmbShare -Name $commonShare.Name -Path $commonPath `
        -FullAccess "$Domain\Domain Admins" `
        -ChangeAccess "$Domain\$($commonShare.Group)" `
        -Description "Partage commun"
}

# --- Vérification ---
Write-Host ""
Write-Host "=== Vérification ===" -ForegroundColor Cyan
Get-SmbShare | Where-Object { $_.Special -eq $false } | Format-Table Name, Path, Description -AutoSize

Write-Host ""
Write-Host "=== ACL NTFS ===" -ForegroundColor Cyan
foreach ($share in ($shares + $commonShare)) {
    $path = Join-Path $DataRoot $share.Name
    Write-Host "--- $($share.Name) ---"
    (Get-Acl $path).Access | Format-Table IdentityReference, FileSystemRights, AccessControlType -AutoSize
}

Write-Host ""
Write-Host "=== Terminé ===" -ForegroundColor Green
