#!/bin/sh -l

echo "Your language is $1."
cd /home/VL
echo $(pwd)
echo "24. 09 2023 4"

if [ $1 = agda ];
then
    echo $GITHUB_WORKSPACE
    ls $GITHUB_WORKSPACE
fi
