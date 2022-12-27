#!/bin/bash

for i in {1..2}; do
  echo "rm -rf /mnt/ramdisk/encfs/out/*"
  rm -rf /mnt/ramdisk/encfs/out/*
  echo "{ time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input preprocess_dataset.py --args --data_dir=/mnt/ramdisk/encfs/data,--results_dir=/mnt/ramdisk/encfs/out; } > /data1/mlcask/logs/io_size/mlperf-tr-imgseg/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1"
  { time env SECCASK_PROFILE_IO=1 gramine-sgx gramine_manifest/encfspython --key ENCFSPYTHON --input preprocess_dataset.py --args --data_dir=/mnt/ramdisk/encfs/data,--results_dir=/mnt/ramdisk/encfs/out; } > /data1/mlcask/logs/io_size/mlperf-tr-imgseg/sgx-encfs_minfa-aes256gcm-iosize-${i}.log 2>&1
done
