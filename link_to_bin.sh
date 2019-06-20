#!/bin/bash


#
# This simple bash script will link any files given in command line to /home/user_dir/bin/
#


usage()
{
	echo "Usage: $0 [-f] script1 script2 script3 etc."
	echo
	echo "-f: overwrites files/symlinks"
}


FORCE="no"

while getopts "f" option; do
	case "${option}" in
		f)
			FORCE="yes"
			;;
		*)	;;
	esac
done

shift $((OPTIND-1))

[ "$#" -lt "1" ] && usage && exit 1

BIN_DIR="/home/$USER/bin"

echo "Overwrites links: $FORCE"
echo "Bin dir: $BIN_DIR"
echo

for file in "$@"; do
	script_path="$(realpath "$file")"
	script_name="$(basename "$file")"
	link_path="$BIN_DIR/$script_name"
	echo "Script path: $script_path"
	echo "Script name: $script_name"
	echo "Link path: $link_path"

	if [[ -e "$link_path" && "$FORCE" == "no" ]]; then
		echo "'$link_path' already exists, skipping..."
	else
		rm -f "$link_path"
		ln -s "$script_path" "$link_path"
	fi
done

