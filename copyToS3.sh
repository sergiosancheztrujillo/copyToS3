#!/bin/bash


LOCAL_FOLDER=$1
echo "Local folder: $LOCAL_FOLDER"
S3_BUCKET=$2
echo "S3 Bucket: $S3_BUCKET"

if  aws s3 ls $S3_BUCKET ; then
    echo "Copying logs files to S3://logfiles"
    if aws s3 cp $LOCAL_FOLDER $S3_BUCKET --recursive ; then
        echo "Copied !!"
        echo "Removing files"
        rm -rf "$LOCAL_FOLDER"*
    else
        echo "OHHH Failed copy to S3 bucket"
    fi
else
    echo "Bucket doesnt exists"
fi



