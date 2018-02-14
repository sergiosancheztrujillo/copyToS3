#!/bin/bash
#
# Script that take two arguments, first the files to copy
# and second, the bucket to copy them

# Note: Its necessary to install AWS CLI and configure
# credentials in AWS CLI (aws configure)


display_help() {
    echo "Usage: $0 <source folder> <S3 bucket> {noremove | remove})"
    echo
    echo "   remove | noremove : remove or not, files from origin after copy"
    echo "   The aws command is executed with --recursive flag "

    exit 1
}

if [[ $1 == "--help" ]] ; then
    display_help
else
    LOCAL_FOLDER=$1
    echo "Local folder: $LOCAL_FOLDER"
    S3_BUCKET=$2
    echo "S3 Bucket: $S3_BUCKET"

    # Firt check if bucket exists
    if aws s3 ls $S3_BUCKET ; then
        if aws s3 cp $LOCAL_FOLDER $S3_BUCKET --recursive ; then
            echo "Files copied !!"
            if [[ $3 == "remove" ]] ; then
                rm -rf "$LOCAL_FOLDER"*
                echo "Files removed from local source"
            else
                echo "Files don't removed"
            fi
        else
            echo "Ups!!, Fail to copy to S3 bucket"
        fi
    else
        echo "Bucket doesnt exists"
    fi
fi



