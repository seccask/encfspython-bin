#!/bin/bash

# taskset -c 32 gramine-sgx gramine_manifest/encfspython --input convert_librispeech.py > sgx-raw.log 2>&1 &
# taskset -c 32 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input convert_librispeech.py > sgx-encfs_minfa-aes256sha256.log 2>&1 &
for i in {1..2}; do
  echo "rm -rf /mnt/ramdisk/encfs/dest/*"
  rm -rf /mnt/ramdisk/encfs/dest/*
  echo "{ time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input convert_librispeech.py; } > ~/sgx/logs/io_size/mlperf-tr-sphrcg/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1"
  { time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input convert_librispeech.py; } > ~/sgx/logs/io_size/mlperf-tr-sphrcg/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1
done
