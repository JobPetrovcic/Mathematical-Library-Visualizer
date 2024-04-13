#!/bin/sh -l
set -e

echo "Your language is $1."
echo "Compiling file: $2."
echo "Mode of presentation: $3."
echo "Install additional libraries: $4."
echo "You flags are: $5"

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
    touch ~/.agda/defaults
    
    if [ $4 = yes ]
    then
        # install libraries in the library_installs_sh
        for file in /library_installs_sh/*.sh; do
            sh $file
        done
        echo "State of ~/.agda/libraries:"
        cat  ~/.agda/libraries
        echo "State of /library_installs_files/agda-stdlib-2.0:"
        ls /library_installs_files/agda-stdlib-2.0
    fi

    PATH_WHERE_LIB_ASSISTANT="test_data/agda/test_lib"

    # clear the test_data/agda/test_lib 
    # TODO do this for lean also
    cd ${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}
    rm * -r

    # move the files that we want to compile so agda-proof-assistant can access it
    cd ${GITHUB_WORKSPACE}/agda-proof-assistent-assistent
    mkdir ${PATH_WHERE_LIB_ASSISTANT}/mylib
    mv ${GITHUB_WORKSPACE}/mylib/* ${PATH_WHERE_LIB_ASSISTANT}/mylib # TODO something is not right here

    echo "Where we moved the library:" #remove
    ls "${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/" # remove

    # move indexer.py to github workspace
    mv /find_source.py .

    # install library
    for file in ${PATH_WHERE_LIB_ASSISTANT}/mylib/*.agda-lib;
    do
        # go through .agda-lib files in directory and
        # install libs
        echo "$(pwd)/${file}" >> ~/.agda/libraries
    done
    
    if [ $2 = autogenerate ]
    then
        # go through .agda-lib files in directory; take the first
        for file in ${PATH_WHERE_LIB_ASSISTANT}/mylib/*.agda-lib;
        do
            echo "Converting library $(basename $file) to s-expressions."

            # get source name
            SOURCE_DEST=$(python3.10 find_source.py ${file})
            echo "Getting a list of all files in the folder ${PATH_WHERE_LIB_ASSISTANT}/mylib/${SOURCE_DEST}..."
            echo "This folder contains:"
            ls ${PATH_WHERE_LIB_ASSISTANT}/mylib/${SOURCE_DEST}

            # create imports.agda which contains all .agda 
            python3.10 indexer.py --directory ${PATH_WHERE_LIB_ASSISTANT}/mylib/${SOURCE_DEST} --recurse

            echo "Generated imports.agda contains:"
            cat "${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/mylib/${SOURCE_DEST}/imports.agda"

            echo "Typechecking..."
            # convert to sexp, use absolute path
            /root/.local/bin/agda --sexp --sexp-dir="${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/sexp" -l $(basename $file .agda-lib) --include-path="${pwd}/${PATH_WHERE_LIB_ASSISTANT}/mylib" $5 "${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/mylib/${SOURCE_DEST}/imports.agda"

            
            break
        done
    else
        echo "Converting $(basename $2) to s-expressions."

        # convert to sexp, use absolute path
        /root/.local/bin/agda --sexp --sexp-dir="${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/sexp" --include-path="${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/mylib" $5 "${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/mylib/$2"
    fi

    echo "Finished typechecking."
    echo "In the test_data/agda are:"
    ls "${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/test_data/agda"

    echo "In the lib assistant directory are:"
    ls "${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}"

    echo "In the sexp directory are:"
    ls "${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/sexp"

    # convert sexp to graph_data.json
    python3.10 main.py
    mv convert_to_web/graph_data.js ${GITHUB_WORKSPACE}/output
    mv convert_to_web/visualize.html ${GITHUB_WORKSPACE}/output 
    mv convert_to_web/index.html ${GITHUB_WORKSPACE}/output 
    mv convert_to_web/scripts ${GITHUB_WORKSPACE}/output
fi