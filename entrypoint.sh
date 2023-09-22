#!/bin/sh -l

echo "HelBlabla lo $1"
time=$(date)
echo "time=$time" >> $GITHUB_OUTPUT

