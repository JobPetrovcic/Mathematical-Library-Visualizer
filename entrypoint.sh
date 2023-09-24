#!/bin/sh -l

echo "Your language is $1."
cd /home/VL
echo $(pwd)
echo "HOME"
echo $(ls /home -R)
echo "GITHUB"
echo $(ls /github -R)
echo "GITHUB/HOME"
echo $(ls /github/home)

echo "24. 09 2023 3"

if [ $1 = agda ];
then
    sudo ./agda_install.sh
    agda --help
fi
