#!/bin/sh -l

echo "Your language is $1."
echo "Compiling file: $2."
echo "Mode of presentation: $3."

# create folder where to output data_graph.json, visualize.json
mkdir output

if [ $1 = agda ];
then
    # add agda to path
    export PATH=/root/.local/bin:$PATH PATH

    # install make and other necessary software
    apt-get install build-essential

    # create folder where to put library files to install
    mkdir /library_installs_files

    # create agda libraries
    mkdir ~/.agda
    touch ~/.agda/libraries
    
    # install libraries in the library_installs_sh
    for file in /library_installs_sh/*.sh; do
        sh $file
    done
    echo "State of ~/.agda/libraries:"
    cat  ~/.agda/libraries

    # move lib so agda-proof-assistant can access it
    PATH_WHERE_LIB_ASSISTANT="test_data/agda/test_lib"
    cd ${GITHUB_WORKSPACE}/agda-proof-assistent-assistent
    rm ${PATH_WHERE_LIB_ASSISTANT} -r
    mv ${GITHUB_WORKSPACE}/mylib ${PATH_WHERE_LIB_ASSISTANT}

    # move indexer.py to github workspace
    mv /find_source.py .

    # we compile the file or the library to get the data, TODO
    
    # go through .agda-lib files in directory; take the first
    for file in ${PATH_WHERE_LIB_ASSISTANT}/*.agda-lib;
    do
        # install lib
        echo "$(pwd)/${file}" >> ~/.agda/libraries

        echo "Converting $(basename $file) to s-expressions."

        # get source name
        SOURCE_DEST=$(python3.10 find_source.py ${file})

        # create imports.agda which contains all .agda 
        python3.10 indexer.py --directory ${PATH_WHERE_LIB_ASSISTANT}/${SOURCE_DEST} --recurse

        # convert to sexp, use absolute path
        /root/.local/bin/agda --sexp --sexp-dir="${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/sexp" -l $(basename $file .agda-lib) --include-path="${pwd}/{PATH_WHERE_LIB_ASSISTANT}" ${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/${SOURCE_DEST}/imports.agda

        python3.10 main.py

        mv convert_to_web/graph_data.js ${GITHUB_WORKSPACE}/output
        mv convert_to_web/visualize.html ${GITHUB_WORKSPACE}/output 
        mv convert_to_web/index.html ${GITHUB_WORKSPACE}/output 

        break
    done
fi