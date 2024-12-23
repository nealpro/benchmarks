#!/bin/bash

# Check if test_file.* files exist
if ls test_file.* 1> /dev/null 2>&1; then
    echo "Test files detected. Skipping file preparation."
else
    # Ask user if they want to prepare the files
    read -p "Test files not detected. Do you want to prepare for the fileio test? (y/n): " answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
        sysbench fileio --file-total-size=5G --file-num=5 prepare
    fi
fi

sysbench --threads=32 cpu run
sysbench --threads=32 mutex run
sysbench fileio --file-total-size=5G --file-num=5 --file-io-mode=async --file-fsync-freq=0 --file-test-mode=rndrd --file-block-size=4k run
sysbench fileio --file-total-size=5G --file-num=5 --file-io-mode=async --file-fsync-freq=0 --file-test-mode=rndwr --file-block-size=4k run
