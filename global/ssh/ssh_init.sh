#!/bin/bash


add_key()
{
	local key_path=$1
	local key
	local key_found

	key=$(awk '{print $2}' "$key_path.pub")
	key_found="$(ssh-add -L | grep "$key")"

	if [ -z "$key_found" ]; then
		echo "Add key '$key_path'"
		ssh-add "$key_path"
	else
		echo "Key '$key_path' already added"
	fi
}

while IFS= read -u 3 -r path; do
	add_key "$path"
done 3< <(find "$HOME/.ssh/" -type f -not -name '*.pub' -not -name '*known_hosts*' -not -name '*authorized_keys*' -not -name '*config*')

