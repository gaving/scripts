#!/bin/zsh
# sort a maildir through bogofilter, placing 'spam' in another folder
# usage: sortspam <spam dir> <target dir>

program_name=$(basename $0)

show_invalid_usage() {
        echo "$program_name: too few arguments
        Try '$program_name <target maildir> <path to spam folder>'"
}

# check there is least two arguments
if [ ! "$#@" -ge 2 ]; then
        show_invalid_usage
        exit
fi

if [ ! -d $@[1]/cur ]; then
	echo "Error: target directory '$@[1]' isn't a directory or isn't a valid maildir!"
	exit
fi

if [ ! -d $@[2]/cur ]; then
	echo "Error: spam directory '$@[2]' doesn't exist or isn't a valid maildir!"
	exit
fi

cd $@[1]/cur
count=0

for i in *; do
    score=$(bogofilter -v -I $i | cut -d, -f3 | cut -d\= -f2)
    if [[ $score > 0.80 ]]; then
		subject=$(grep '^Subject:' $i)
		echo "[$score]: $subject"
        mv $i $@[2]/new
		((count++))
    fi
done

total=$(ls -1 $@[1]/cur/ | wc -l)
percentage=$(echo "scale=3; $count/$total*100" | bc)

echo "_____"
echo "Filtered $count mails out of a total of $total (~$percentage%)"
