#!/bin/sh -l

echo "Your language is $1."
cd /home/VL
echo $(pwd)
echo $PATH
echo "24. 09 2023 4"

if [ $1 = agda ];
then
    sudo ./agda_install.sh
    agda --help
fi
