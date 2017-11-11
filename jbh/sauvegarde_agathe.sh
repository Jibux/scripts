#!/bin/bash


LOG="$HOME/logs/sauvegarde.log"
ERR_LOG="$HOME/logs/sauvegarde_erreurs.log"

BEGIN_MSG="Sauvegarde commencée le $(date)"
echo "$BEGIN_MSG" > $LOG
echo "$BEGIN_MSG" > $ERR_LOG

SOURCE="/mnt2/DONNEES/Fichiers"
DESTINATION="/mnt/nas_agathe"

rsync -a --delete --progress $SOURCE $DESTINATION/ 2>>$ERR_LOG | tee --append $LOG | zenity --text="Sauvegarde en cours..." --progress --pulsate --auto-kill --auto-close

END_MSG="Sauvegarde finie le $(date)"
echo "$END_MSG" >> $LOG
echo "$END_MSG" >> $ERR_LOG

ECHO_MSG="La sauvegarde s'est terminée"

if [ "$(wc -l $ERR_LOG | awk '{print $1}')" == "2" ]; then
	zenity --info --text="$ECHO_MSG sans erreur."
else
	zenity --error --text="$ECHO_MSG AVEC des erreurs ! Voir le fichier $ERR_LOG."
fi

