#!/bin/bash

# Uncomment for debugging
#set -o xtrace

# Set default variables
START=$(date +%s)
DATE=$(date +%F.%H.%M.%S)

# Source file with various functions
source utilities/functions.sh

# print the happy snake ascii
happy-snake-ascii

trap die ERR SIGKILL SIGINT

if [[ ${#@} -gt 1 ]]; then
	err "Only one argument allowed"
	usage
fi

MODE=
while getopts 'sdh' flag; do
	case "${flag}" in
	s)
		s=${OPTARG}
		MODE=singularity
		;;
	d)
		d=${OPTARG}
		MODE=docker
		;;
	h)
		h=${OPTARG}
		usage
		;;
	esac
done

if [[ -z $MODE ]]; then
	err "Must use either -s or -d flag"
	usage
fi

if [[ $MODE == docker ]]; then
	# Run the workflow with docker
	docker run \
	--rm \
	-ti \
	-u 1000:1000 \
	-v $(pwd):/data \
	-w /data \
	oskarv/happy-snake snakemake -j -p
elif [[ $MODE == "singularity" ]]; then
	# Run the workflow with singularity
	singularity exec \
	-B $(pwd):/data \
	-W /data \
	singularity/happy-snake.simg snakemake -j -p
fi

# End by printing some benchmarking data for funsies
FINISH=$(date +%s)
EXECTIME=$(( $FINISH-$START ))
inf "Exited on $(date)"
printf "[$(showdate)][INFO]: Duration: %dd:%dh:%dm:%ds\n" $((EXECTIME/86400)) $((EXECTIME%86400/3600)) $((EXECTIME%3600/60)) $((EXECTIME%60))
