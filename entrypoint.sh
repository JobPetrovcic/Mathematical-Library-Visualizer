#!/bin/sh -l

echo "Your language is $1."
echo "8 1 2024"
ls ${GITHUB_WORKSPACE}

if [ $1 = agda ];
then
    # move lib so agda-proof-assistant can access it
    PATH_WHERE_LIB_ASSISTANT="test_data/agda/test_lib"
    cd ${GITHUB_WORKSPACE}/agda-proof-assistent-assistent
    rm ${PATH_WHERE_LIB_ASSISTANT} -r
    mv ${GITHUB_WORKSPACE}/mylib ${PATH_WHERE_LIB_ASSISTANT}

    # move indexer.py to github workspace
    mv /find_source.py .
    
    # go through .agda-lib files in directory; take the first
    for file in ${PATH_WHERE_LIB_ASSISTANT}/*.agda-lib;
    do
        # install lib
        mkdir ~/.agda
        touch ~/.agda/libraries
        echo "$(pwd)/${file}" >> ~/.agda/libraries

        #echo "Converting $(basename $file) to s-expressions."

        # get source name
        SOURCE_DEST=$(python3.10 ${GITHUB_WORKSPACE}/find_source.py ${file})

        # create imports.agda which contains all .agda 
        python3.10 indexer.py --directory ${PATH_WHERE_LIB_ASSISTANT}/${SOURCE_DEST} --recurse

        # convert to sexp
        /root/.local/bin/agda --sexp --sexp-dir="${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/sexp" -l $(basename $file .agda-lib) --include-path="${pwd}/#{PATH_WHERE_LIB_ASSISTANT}" ${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/${SOURCE_DEST}/imports.agda

        python3.10 main.py
        
        break
    done
fi

ls convert_to_web