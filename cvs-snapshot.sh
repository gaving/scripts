#!/bin/sh
# cvs snapshot script
# usage: ./cvs-snapshot <module> [folder]
# note: will overwrite any file that exists locally!

tag=`date +%Y%m%d` # tag to label archives
dir=~/snapshots # path to store tarballs

if [ ! "$1" ]; then
    echo "Error: No module specified."
    echo "Usage: $0 <module> [folder/]"
    exit
fi

if [ "$2" ]; then
    dir=$2
fi

module=$1

mkdir -p ${dir} && \
    cd ${dir} && \
    cvs -Q -z3 export -d ${1}_${tag} -r HEAD ${module} && \
    tar -c -z --exclude CVS -f ${dir}/${1}_${tag}.tar.gz ${1}_${tag} && \
    rm -r ${dir}/${1}_${tag}
