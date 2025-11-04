#!/bin/bash

set -euo pipefail

# --- config ---

SRC_DIR="/home/serhiy/Desktop/progetto_test/data"
BACKUP_DIR="/home/serhiy/Desktop/progetto_test/backups"
LOG_DIR="/home/serhiy/Desktop/progetto_test/logs"
LOG_FILE="$LOG_DIR/backup.log"
NUM_BACKUPS=5

mkdir -p "BACKUP_DIR" "$LOG_DIR"

TS="$(date +%F_%H-%M-%S)"
HOST="$(hostname)"
SECONDS=0

echo "------------------------------"  |tee -a "LOG_FILE" 
echo "Run at $TS (host: $HOST)"  |tee -a "LOG_FILE"

#sanity check

if [ ! -d "$SRC_DIR" ]; then
echo "ERROR: SRC_DIR not found: $SRC_DIR" | tee -a "$LOG_FILE"
exit 1
fi

# crea il backup 

ARCHIVE="$BACKUP_DIR/data-backup-$TS.tar.gz"
if tar -czf "$ARCHIVE" -C "$SRC_DIR" .; then
echo "Backup OK: $ARCHIVE" | tee -a "$LOG_FILE"
else 
echo "Backup FAILED" | tee -a "$LOG_FILE"
exit 1
fi

#size + duration

SIZE="$(du -h "$ARCHIVE" | awk '{print $1}')"
echo "Backup size: $SIZE"  |tee -a "LOG_FILE"
echo "Duration: ${SECONDS}s"  |tee -a "LOG_FILE"

#keep only the 5 most recent backups 
#elenco dei .tar.gz ordinati dal piu recente al piu vecchio (puo essere vuoto)

BACKUPS_LIST=$(ls -1t "$BACKUP_DIR"/*.tar.gz 2>/dev/null || true)
BACKUP_COUNT=$(printf "%s\n" "$BACKUPS_LIST" | grep -c . || true)
if [ "$BACKUP_COUNT" -gt "$NUM_BACKUPS" ]; then
echo "Cleaning older backups..."  |tee -a "LOG_FILE"
printf "%s\n" "$BACKUPS_LIST" | tail -n +$((NUM_BACKUPS + 1)) | while IFS= read -r old_backup; do
rm -f -- "$old_backup"
echo "Removed: $old_backup"  |tee -a "LOG_FILE"
done
fi

# spazio disco (partizione root)

DISK_USAGE="$(df -h / | awk 'NR==2{print $3 "/" $2 " used (" $5 ")"}')"
MEM_LINE="$(free -h | awk 'NR==2{print $2 " total, " $3 " used, " $4 " free"}')"

echo "Disk : $DISK_USAGE"  |tee -a "LOG_FILE"
echo "RAM : $MEM_LINE"  |tee -a "LOG_FILE"
