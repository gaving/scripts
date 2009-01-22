#!/bin/zsh
# upload script (a rewrite using zsh's built-in ftp functions)
# usage: upload [-[h/p <path>]] <filenames> (path defaults to 'upload')
# note: will overwrite any file that exists on remote(!)

program_name=$(basename $0)

# get passwords and proper variables from secrets file
source $HOME/local/share/.secrets

show_invalid_usage() {
    echo "$program_name: too few arguments (or first parameter non-existant)
 Try '$program_name --help' for more information."
}

show_help() {
    echo "Usage: $program_name [OPTION]... FILE...
 Upload a file to a remote ftp server 

 -p, --path          remote path to send file
 -h, --help          display this help and exit"
}

# handle command line arguments
while [[ $1 == -* ]]; do
    case "$1" in
        -h|--help) show_help; exit 0;;
        -c|--clipboard); clipboard=1; shift;;
        -p|--path) 
        if [ "$2" ]; then
            ftp_upload_path=$2
            shift 2
        else
            show_help
            exit
        fi
        ;;
    esac
done

# check there is at least one argument (and it exists)
if [ ! "$@[1]" ] || [ ! -e "$@[1]" ]; then
    show_invalid_usage;
    exit
fi

# attempt upload
if [ ! "$clipboard" ]; then
	echo -n "Attempting upload "
fi

autoload -U zfinit
zfinit
zfopen "$ftp_host/$ftp_path_prefix/$ftp_upload_path" "$ftp_user" "$ftp_pass"
for i in "$@"; do
    if [ ! -e "$i" ]; then
        echo "Error: '$i' doesn't exist (ignored)"
	elif [ -d "$i" ]; then
		zfput -r $i
    else
        zfput "$i"
    fi
done

if [ ! "$clipboard" ]; then
	zfstat -v
fi

zfclose
