# terminate on error
set -e

# go to designated folder where we install the libraries
cd /library_installs_files

# copy files and extract
wget -O agda-stdlib.tar https://github.com/agda/agda-stdlib/archive/v2.0.tar.gz > /dev/null
tar -zxf agda-stdlib.tar > /dev/null
folder_name=`tar -tzf agda-stdlib.tar | head -1 | cut -f1 -d"/"`

# add it to agda imports
echo "/library_installs_files/${folder_name}/agda-stdlib.agda-lib" >> ~/.agda/libraries

echo "Installed agda-stdlib."