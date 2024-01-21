# terminate on error
set -e

# go to designated folder where we install the libraries
cd /library_installs_files

# copy files and extract
git clone https://github.com/UniMath/agda-unimath > /dev/null

# add it to agda imports
echo "/library_installs_files/agda-stdlib/agda-unimath.agda-lib" >> ~/.agda/libraries

echo "Installed agda-unimath."