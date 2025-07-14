#!/bin/bash
## Intended usage:
##  RUNNER_IMAGE=alpine:latest CONTAINER_SHELL=/bin/ash singularity-runner.sh -B /volume << EOF
##  echo "Hello world"
##  EOF


## Parse the input options 
export RUNNER_IMAGE=${RUNNER_IMAGE:-docker://ubuntu:latest}
export APPTAINER_CACHEDIR=${APPTAINER_CACHEDIR:-/tmp/apptainer_cache}
export APPTAINER_TMPDIR=${APPTAINER_TMPDIR:-/tmp/apptainer_tmp}
export REPOSITORY_HOST_PATH=${REPOSITORY_HOST_PATH:-$PWD}
export REPOSITORY_CONTAINER_PATH=${REPOSITORY_CONTAINER_PATH:-/gha-$RANDOM}
export CONTAINER_SHELL=${CONTAINER_SHELL:-/bin/bash}

## Defines a temporary file 
TMPFILE=/tmp/runner-cmd/$RANDOM.sh

## Defines the working directory 

## Create the directory and initialize the file 
mkdir -p $(dirname $TMPFILE)
echo "cd /$REPOSITORY_CONTAINER_PATH" > $TMPFILE
cat >> $TMPFILE

## Moves to a certainly-writable area
mkdir /tmp/working-dir
cd /tmp/working-dir


## Execute the container 
apptainer exec \
    -B /cvmfs:/cvmfs:ro \
    -B $TMPFILE:/entrypoint.sh:ro \
    -B $REPOSITORY_HOST_PATH:$REPOSITORY_CONTAINER_PATH \
    $RUNNER_IMAGE \
    $CONTAINER_SHELL $TMPFILE

## Clean up
rm $TMPFILE
