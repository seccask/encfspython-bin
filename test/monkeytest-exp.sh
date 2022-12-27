#!/bin/bash

# split arguments from string "gramine-direct ./gramine_manifest/python ./monkeytest.py -r 4096 -w 4096 -s 512"

# BLOCK_SIZES="4096 8192 16384 32768 65536 131072 262144 524288" # 1048576
# BLOCK_SIZES="524288 262144 131072 65536 32768 16384 8192 4096"
# BLOCK_SIZES="512 256 128 64 32 16 8 4"
BLOCK_SIZES="4096 2048 1024"
INPUT_SCRIPT=/home/mlcask/sgx/encfspython/monkeytest.py

for i in {1..1} ; do
  for block_size in $BLOCK_SIZES; do
    TEST_FILE_MB=4096
    READ_BLOCK_KB=$block_size
    WRITE_BLOCK_KB=$block_size

    ################################################################################

    # SETUP=untrusted-direct
    # ENV_VARS=(PYTHONHOME=~/sgx/lib/cpython-3.9.13-install PYTHONPATH=/home/mlcask/scvenv-autolearn/lib/python3.9/site-packages)
    # PROGRAM_NAME=/home/mlcask/sgx/encfspython/build/bin/encfspython
    # TEST_FILE_PATH=/mnt/ramdisk/raw/monkeytest

    # echo "SETUP: $SETUP, RB_KB: $READ_BLOCK_KB, WB_KB: $WRITE_BLOCK_KB, TF_MB: $TEST_FILE_MB"
    # echo "env ${ENV_VARS[@]} $PROGRAM_NAME --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"
    # env ${ENV_VARS[@]} $PROGRAM_NAME --input $INPUT_SCRIPT --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> "mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"

    # SETUP=sgx-direct
    # PROGRAM_NAME=gramine-sgx
    # MANIFEST_PATH=./gramine_manifest/encfspython
    # TEST_FILE_PATH=/mnt/ramdisk/raw/monkeytest

    # echo "SETUP: $SETUP, RB_KB: $READ_BLOCK_KB, WB_KB: $WRITE_BLOCK_KB, TF_MB: $TEST_FILE_MB"
    # echo "$PROGRAM_NAME $MANIFEST_PATH --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"
    # $PROGRAM_NAME $MANIFEST_PATH --input $INPUT_SCRIPT --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> "mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"
    
    ################################################################################

    SETUP=sgx-encfs-aes256gcm-c1mb
    # ENV_VARS=(SECCASK_DEBUG_ENCFS=1)
    ENV_VARS=()
    PROGRAM_NAME=gramine-sgx
    MANIFEST_PATH=./gramine_manifest/encfspython
    TEST_FILE_PATH=/mnt/ramdisk/encfs/monkeytest

    echo "SETUP: $SETUP, RB_KB: $READ_BLOCK_KB, WB_KB: $WRITE_BLOCK_KB, TF_MB: $TEST_FILE_MB"
    echo "env ${ENV_VARS[@]} $PROGRAM_NAME $MANIFEST_PATH --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"
    env ${ENV_VARS[@]} $PROGRAM_NAME $MANIFEST_PATH --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> "mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"

    SETUP=untrusted-encfs-aes256gcm-c1mb
    ENV_VARS=(PYTHONHOME=~/sgx/lib/cpython-3.9.13-install PYTHONPATH=/home/mlcask/scvenv-autolearn/lib/python3.9/site-packages)
    PROGRAM_NAME=/home/mlcask/sgx/encfspython/build/bin/encfspython
    TEST_FILE_PATH=/mnt/ramdisk/encfs/monkeytest

    echo "SETUP: $SETUP, RB_KB: $READ_BLOCK_KB, WB_KB: $WRITE_BLOCK_KB, TF_MB: $TEST_FILE_MB"
    echo "env ${ENV_VARS[@]} $PROGRAM_NAME --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"
    env ${ENV_VARS[@]} $PROGRAM_NAME --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> "mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"

    ################################################################################

    # SETUP=untrusted-protectedfs
    # PROGRAM_NAME=gramine-direct
    # MANIFEST_PATH=./gramine_manifest/encfspython
    # TEST_FILE_PATH=/mnt/ramdisk/protectedfs/monkeytest

    # echo "SETUP: $SETUP, RB_KB: $READ_BLOCK_KB, WB_KB: $WRITE_BLOCK_KB, TF_MB: $TEST_FILE_MB"
    # echo "$PROGRAM_NAME $MANIFEST_PATH --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"
    # $PROGRAM_NAME $MANIFEST_PATH --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> "mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"

    # SETUP=sgx-protectedfs
    # PROGRAM_NAME=gramine-sgx
    # MANIFEST_PATH=./gramine_manifest/encfspython
    # TEST_FILE_PATH=/mnt/ramdisk/protectedfs/monkeytest

    # echo "SETUP: $SETUP, RB_KB: $READ_BLOCK_KB, WB_KB: $WRITE_BLOCK_KB, TF_MB: $TEST_FILE_MB"
    # echo "$PROGRAM_NAME $MANIFEST_PATH --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"
    # $PROGRAM_NAME $MANIFEST_PATH --input $INPUT_SCRIPT --key ENCFSPYTHON --args -r,$READ_BLOCK_KB,-w,$WRITE_BLOCK_KB,-s,$TEST_FILE_MB,-f,$TEST_FILE_PATH >> "mk_${SETUP}_rb_${READ_BLOCK_KB}kb_wb_${WRITE_BLOCK_KB}kb_tf_${TEST_FILE_MB}mb.results"
  done
done