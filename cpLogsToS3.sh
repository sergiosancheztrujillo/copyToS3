#!/usr/bin/env bash

display_help() {
    echo "Usage: $0 <days old> {noremove | remove}) "
    echo
    echo "             days old: files with date creation older than "days old" that we want to copy or move."
    echo "   remove | noremove : remove or not, files from origin after copy."
    echo "   The aws command is executed with --recursive flag "

    exit 1
}

move_files(){
    year=$(echo $1 | awk -F"/" '{print $5}')
    echo "Moving Year: ${year}"
    echo "Old days: $2"
    find /remote/backups/logbackup/${year}/ -mtime +$2 -exec aws s3 mv {} s3://basebone.backups.logs/$HOSTNAME/${year}/  \;

}

copy_files(){
    year=$(echo $1 | awk -F"/" '{print $5}')
    echo "Copying Year: ${year}"
    echo "Old days: $2"
    find /remote/backups/logbackup/${year}/ -mtime +$2 -exec aws s3 cp {} s3://basebone.backups.logs/$HOSTNAME/${year}/  \;

}

S3_BUCKET="s3://basebone.backups.logs"
OLD_DAYS=$1

if [[ $1 == "--help" ]] ; then
    display_help
else
    # Firt check if bucket exists
    if aws s3 ls ${S3_BUCKET} ; then
        for dir in /remote/backups/logbackup/*/; do
            folder=${dir}
            if [[ $2 == "remove" ]] ; then
                move_files ${folder} $OLD_DAYS
            elif [[ $2 == "noremove" ]] ; then
                copy_files ${folder} $OLD_DAYS
            else
                echo "Please, specify if you want to remove or not the files"
            fi
        done
    else
        echo "Bucket doesnt exists"
    fi
fi
