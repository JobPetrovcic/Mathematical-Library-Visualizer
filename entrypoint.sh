#!/bin/sh -l

echo "Your language is $1."
echo $(pwd)
echo "HOME"
echo $(ls /home)
echo "GITHUB"
echo $(/github)
echo "GITHUB/HOME"
echo $(ls /github/home)

echo "24. 09 2023 2"

if [ $1 = agda ];
then
    sudo ./agda_install.sh
    agda --help
fi
