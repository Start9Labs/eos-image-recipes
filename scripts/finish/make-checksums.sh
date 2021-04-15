#!/bin/sh
set -e

RESULTS_DIR=$1

# write checksum files
cd $RESULTS_DIR
find -type f \( -not -name "checksums.*.txt" \) -exec sha256sum '{}' \; > checksums.sha256.txt
find -type f \( -not -name "checksums.*.txt" \) -exec b2sum '{}' \; > checksums.blake2.txt
