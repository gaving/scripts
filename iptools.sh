#!/bin/zsh
# ip tool for some handy dyndns management
# usage: iptool [-[u/v]]

program_name=$(basename $0)

show_invalid_usage() {
    echo "$program_name: too few arguments
 Try '$program_name --help' for more information."
}

show_help() {
    echo "Usage: $program_name [OPTION]... FILE...
 Simple tool for managing a dynamic IP

 -u, --update          update your record to match ip
 -v, --view            view current ip"
}

# check there is at least one flag 
if [ ! "$@[1]" ]; then
    show_invalid_usage;
    exit
fi;

# handle command line arguments
while [[ $1 == -* ]]; do
    case "$1" in
        -h|--help) show_help; exit 0;;
		-v|--view)
		curl -s http://checkip.dyndns.org | awk '{print $6}' | awk ' BEGIN { FS = "<" } { print $1 } '
		exit 0
		;;
        -u|--update)
		curl -s "http://freedns.afraid.org/dynamic/update.php?UUUzemJrSnp0QmdBQVVoZ3VlTTo4NTU4Njk="
		exit 0
        ;;
    esac
done
