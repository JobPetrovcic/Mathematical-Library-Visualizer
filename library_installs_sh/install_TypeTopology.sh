# terminate on error
set -e

# go to designated library where we install the libraries
cd /libraries_installs_files

# copy files
git clone https://github.com/martinescardo/TypeTopology

# go to folder, then use make, i. e. install library
cd TypeTopology
make

# add it to agda imports
echo "/libraries_installs_files/TypeTopology/typetopology.agda-lib" >> ~/.agda/libraries

echo "Installed TypeTopology."