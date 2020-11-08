#!/bin/bash


#
# This script is parsing directories and moving the pattern matched files to the places defined in config.local
# Input:
#   directories
#
# The script is going through the directories specified in arguments.
# then list all the files contained in them
# then checking if they match with one of the patterns written in config.local
# if a file match with a pattern, it will be moved to the corresponding directory
# written in config.local in the same line of this pattern.
#
# See 'config.sample' to setup your own config.local
#


set -o errexit -o nounset -o errtrace

SCRIPT_ROOT_PATH="$(dirname "$(realpath "$0")")"
CONFIG_FILE="$SCRIPT_ROOT_PATH/config.local"
CONFIG_SEPARATOR="|||"

ACTION_CMD=""
CREATE_DIR=""
EXISTING_FILES=""
ACTION="move"

generic_err()
{
	fail "Something went wrong, exiting..."
}

fail()
{
	echo "$1" >&2
	exit 1
}

usage()
{
	echo "Usage: $0 [OPTIONS] list of directories"
	echo
	echo "-c (optional): use 'copy' instead of default 'move' action"
	echo
	echo "Example: $0 ~/Downloads/ /home/owncloud/"
}

clean_path()
{
	local path=$1
	local path_nodupslash="${path//\/*(\/)/\/}"
	echo "${path_nodupslash%%/}"
}

get_parent_dir()
{
	local tmp_path=${1%%\$*}

	if [[ "$tmp_path" =~ /$ ]]; then
		clean_path "$tmp_path"
	else
		local tmp_path2="${tmp_path%/*}"
		clean_path "$tmp_path2"
	fi
}

stack_command()
{
	[ -z "$2" ] && fail "stack_command() need 2 arguments"
	case "$1" in
	move)
		ACTION_CMD="$ACTION_CMD""mv -f $2;"
		;;
	copy)
		ACTION_CMD="$ACTION_CMD""cp -f $2;"
		;;
	create_dir)
		CREATE_DIR="$CREATE_DIR""mkdir -p '$2';"
		;;
	*)
		fail "Unrecognized action '$1'"
		;;
	esac
}

process_file()
{
	local file=$1
	local file_name
	local destination
	local destination_parent
	local pattern
	local destination_not_evaluated

	[ ! -f "$file" ] && fail "'$file' does not exist!"
	file_name="$(clean_path "$(basename "$file")")"
	echo "Process '$file_name'"

	while IFS= read -r line; do
		[[ "$line" =~ ^# ]] && continue
		[[ -z "$line" ]] && continue

		pattern=${line%$CONFIG_SEPARATOR*}
		destination_not_evaluated=${line#*$CONFIG_SEPARATOR}

		if [[ "$file_name" =~ $pattern ]]; then
			destination="$(clean_path "$(eval echo "$destination_not_evaluated")")"
			if [ -e "$destination" ]; then
				if [[ ! -d "$destination" || ! -w "$destination" ]]; then
					fail "'$destination' is not a directory or is not writable!"
				fi
			else
				destination_parent="$(get_parent_dir "$destination_not_evaluated")"
				if [[ -d "$destination_parent" && -w "$destination_parent" ]]; then
					stack_command "create_dir" "$destination"
				else
					fail "Directory '$destination_parent' does not exist or is not writable!"
				fi
			fi
			[ -f "$destination/$file_name" ] && EXISTING_FILES="$EXISTING_FILES""- $destination/$file_name\\n"
			stack_command "$ACTION" "'$file' '$destination/'"
		fi

	done < "$CONFIG_FILE"
}

trap generic_err ERR

[ ! -f "$CONFIG_FILE" ] && fail "Config file '$CONFIG_FILE' not found!"

optstring=":c"

while getopts ${optstring} arg; do
	case "${arg}" in
	c)
		ACTION="copy"
		shift;;
	:)
		fail "$0: Must supply an argument to -$OPTARG";;
	?)
		fail "Invalid option: -$OPTARG"
		usage
		exit 1;;
	esac
done

[ "$#" -lt "1" ] && usage && exit 1

while IFS= read -r -d '' file; do
	process_file "$file"
done < <(find "$@" -maxdepth 1 -type f -print0)

echo ""

if [ -z "$ACTION_CMD" ]; then
	echo -e "Nothing to do... exiting."
	exit 0
fi

if [ -n "$EXISTING_FILES" ]; then
	echo -e "WARNING: the files below already exist"
	echo -e "$EXISTING_FILES"
fi

echo -e "Will do:\\n"
[ -n "$CREATE_DIR" ] && echo -e "${CREATE_DIR//;/\\n}"
echo -e "${ACTION_CMD//;/\\n}"

read -p"Proceed? (y/N) " response

if [[ ! "$response" =~ ^([yY]|yes|YES|Yes)$ ]]; then
	echo "Abort."
else
	echo "Execute commands..."
	eval "$CREATE_DIR"
	eval "$ACTION_CMD"
fi

exit 0

