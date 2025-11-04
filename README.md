Linux Backup and Monitoring Script
----------------------------------

Questo progetto contiene uno script Bash che esegue automaticamente il backup di una cartella, salva un file compresso con data e ora, registra le informazioni in un file di log e cancella i backup piu vecchi mantenendo solo gli ultimi 5.

1. Funzionalita principali
   - Crea un backup della cartella "data" in formato .tar.gz
   - Inserisce data e ora nel nome del file del backup
   - Salva i file di backup nella cartella "backups"
   - Registra l'esito nel file "logs/backup.log"
   - Aggiunge al log: dimensione del backup, durata, uso RAM e Disco
   - Se il numero di backup supera 5, elimina automaticamente i piu vecchi
   - Lo script puo essere eseguito automaticamente tramite cron

2. Struttura del progetto

   progetto_test/
   |- backup_monitor.sh
   |- data/
   |- backups/
   |- logs/
   |- README.md

3. Configurazione
   Aprire il file "backup_monitor.sh" e controllare queste righe:

   SRC_DIR="/home/serhiy/Desktop/progetto_test/data"
   BACKUP_DIR="/home/serhiy/Desktop/progetto_test/backups"
   LOG_DIR="/home/serhiy/Desktop/progetto_test/logs"
   NUM_BACKUPS=5

4. Esecuzione manuale
   Aprire il terminale ed eseguire:

   cd /home/serhiy/Desktop/progetto_test
   chmod +x backup_monitor.sh
   ./backup_monitor.sh

   Il backup verra salvato nella cartella "backups".
   Nel file "logs/backup.log" verra registrato l'esito.

5. Automazione con cron (esempio ogni 15 minuti)
   Aprire il crontab:

   crontab -e

   Aggiungere questa riga in fondo al file:

   */15 * * * * /home/serhiy/Desktop/progetto_test/backup_monitor.sh >> /home/serhiy/Desktop/progetto_test/logs/cron.out 2>&1

   Salvare ed uscire.
   Cron eseguira lo script ogni 15 minuti e salvera eventuali messaggi in "cron.out".

6. Ripristino di un backup
   Per estrarre un backup manualmente:

   mkdir /home/serhiy/Desktop/ripristino
   tar -xzf /home/serhiy/Desktop/progetto_test/backups/nome-del-backup.tar.gz -C /home/serhiy/Desktop/ripristino

7. Comandi Linux utilizzati nello script
   - tar (per creare archivi compressi)
   - gzip
   - df -h (controllo spazio disco)
   - free -h (controllo memoria RAM)
   - awk (formattazione testo)
   - tee (scrive su file e su schermo)
   - cron (automazione)
   - rm (cancellazione file vecchi)
   - set -euo pipefail (interrompe lo script in caso di errore)

8. Idee future
   - Backup su server remoto tramite ssh o rsync
   - Notifica email in caso di errore
   - Ripristino automatico
   - Interfaccia semplificata tramite menu
