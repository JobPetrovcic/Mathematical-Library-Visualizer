# terminate on error
set -e

# go to designated folder where we install the libraries
cd /library_installs_files

# copy files and extract
wget -O agda-stdlib.tar https://github.com/agda/agda-stdlib/archive/v2.0.tar.gz > /dev/null
tar -zxvf agda-stdlib.tar > /dev/null

# add it to agda imports
echo "/library_installs_files/agda-stdlib/agda-stdlib.agda-lib" >> ~/.agda/libraries

echo "Installed agda-stdlib."