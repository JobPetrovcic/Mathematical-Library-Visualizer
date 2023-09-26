#!/bin/sh -l

set -euo

echo "Your language is $1."
echo "24. 09 2023 5"

if [ $1 = agda ];
then
    # move lib where 
    cd ${GITHUB_WORKSPACE}/agda-proof-assistent-assistent
    PATH_WHERE_LIB_ASSISTANT = "test_data/agda/test_lib"
    rm ${PATH_WHERE_LIB_ASSISTANT} -r
    mv ${GITHUB_WORKSPACE}/mylib ${PATH_WHERE_LIB_ASSISTANT}

    # go through .agda-lib files in directory; take the first
    # TODO 
    #for file in ${GIT_CLONE_FILES}/*.agda-lib;
    #do
    #    echo "Concerting $(basename $file).agda-lib to s-expressions."
    #    agda --sexp --sexp-dir="${GITHUB_WORKSPACE}/agda-proof-assistent-assistent/${PATH_WHERE_LIB_ASSISTANT}/sexp" -l $(basename $1 .agda-lib) #--include-path=$cwd $path_to_all_files
    #    break
    #done
fi
