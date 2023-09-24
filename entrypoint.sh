#!/bin/sh -l

echo "Your language is $1."
cd /home/VL
echo $(pwd)
echo "GHC"
echo $(ls /opt/ghc/9.4.5/bin -R)
echo "24. 09 2023 3"

if [ $1 = agda ];
then
    sudo ./agda_install.sh
    agda --help
fi
