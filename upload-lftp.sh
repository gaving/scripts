#!/bin/bash
# upload script (lftp edition)
# usage: upload <filename> <folder> (defaults to 'upload')
# note: will overwrite any file that exists on remote(!)

# get passwords and proper variables from secrets file
source $HOME/share/.secrets

# sanity check file exists
if [ ! -e "$1" ]; then
	echo "Error: '$1' doesn't exist."
        echo "Usage: $0 <filename> [folder/]"
        exit
fi

# default folder to upload to 
if [ "$2" ]; then
    echo "word"
    ftp_dir=$2
fi

echo "Attempting to upload '$1' to $ftp_path/$ftp_dir.."

# execute lftp with the appropriate options
lftp <<EOF
    open $ftp_server
    user $ftp_user $ftp_pass
    cd $ftp_path/$ftp_dir
    put "$1"
    bye
EOF

echo "Done."
