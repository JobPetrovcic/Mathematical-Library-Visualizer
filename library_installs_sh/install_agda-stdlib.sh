# terminate on error
set -e

# go to designated library where we install the libraries
cd /libraries_installs_files

# copy files and extract
wget -O agda-stdlib.tar https://github.com/agda/agda-stdlib/archive/v2.0.tar.gz
tar -zxvf agda-stdlib.tar

# add it to agda imports
echo "$/libraries_installs_files/agda-stdlib/agda-stdlib.agda-lib" >> ~/.agda/libraries

echo "Installed agda-stdlib."