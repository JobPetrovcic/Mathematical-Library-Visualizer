#!/bin/sh -l

echo "Your language is $1."
echo $(ls)
echo "24. 09 2023 2"

if [ $1 = agda ];
then
    sudo ./agda_install.sh
    agda --help
fi
