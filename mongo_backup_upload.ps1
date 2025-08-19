# MongoDB + Google Drive Backup Script using Rclone
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupDir = "C:\MongoBackup\$timestamp"
$mongoHost = "localhost"
$mongoPort = "27017"
$dbName = "mydata"  
$dumpPath = "C:\Users\Ashu\Downloads\mongodb-database-tools-windows-x86_64-100.12.2 (1)\mongodb-database-tools-windows-x86_64-100.12.2\bin\mongodump.exe"
$rclonePath = "$HOME\Desktop\rclone.exe"

# Create backup folder
New-Item -ItemType Directory -Force -Path $backupDir

# Take MongoDB dump
& "$dumpPath" --host $mongoHost --port $mongoPort --db $dbName --out $backupDir

# Upload backup to Google Drive
& "$rclonePath" copy "$backupDir" "gdrive:MongoBackup/$timestamp" --progress

# Delete old backups (older than 7 days)
Get-ChildItem "C:\MongoBackup" | Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-7) } | Remove-Item -Recurse -Force
