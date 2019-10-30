#!/bin/bash

# Uncomment for debugging
#set -o xtrace

# Set default variables
START=$(date +%s)
DATE=$(date +%F.%H.%M.%S)
REFERENCES=$(pwd)/references

# Source file with various functions
source utilities/functions.sh

# print the happy snake ascii
happy-snake-ascii

trap die ERR SIGKILL SIGINT

# Function that gives the user troubleshooting information and attempts to clean up stray files so as not to litter the intermediary workflow directory
die () {
	printf "\n\n#########################################\n"
	err "$0 failed at line $BASH_LINENO"
	# Print benchmarking data
	FINISH=$(date +%s)
	EXECTIME=$(( $FINISH-$START ))
	inf "Exited on $(date)"
	printf "[$(showdate)][INFO]: Duration: %dd:%dh:%dm:%ds\n" $((EXECTIME/86400)) $((EXECTIME%86400/3600)) $((EXECTIME%3600/60)) $((EXECTIME%60))
	printf "#########################################\n"
	exit 1
}

# Run the workflow
docker run \
--rm \
-ti \
-u $(id -u):$(id -g) \
-v $REFERENCES:/references \
-v $(pwd):/data \
-w /data \
oskarv/happy-snake snakemake -j -p

# End by printing some benchmarking data for funsies
FINISH=$(date +%s)
EXECTIME=$(( $FINISH-$START ))
inf "Exited on $(date)"
printf "[$(showdate)][INFO]: Duration: %dd:%dh:%dm:%ds\n" $((EXECTIME/86400)) $((EXECTIME%86400/3600)) $((EXECTIME%3600/60)) $((EXECTIME%60))
